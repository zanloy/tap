class Ticket < ActiveRecord::Base

  PRIORITIES = %w[low normal urgent]

  after_create :send_notification
  after_save :notify_assignee, :set_state

  # Associations
  belongs_to :project
  belongs_to :reporter, class_name: User
  belongs_to :assignee, class_name: User
  belongs_to :closed_by, class_name: User
  belongs_to :approving_manager, class_name: User
  belongs_to :approving_executive, class_name: User
  has_many :purchases, dependent: :delete_all
  has_many :comments, dependent: :delete_all

  accepts_nested_attributes_for :purchases, reject_if: :all_blank, allow_destroy: true

  # Validation
  validates_presence_of :project, :reporter, :priority, :title
  validates_numericality_of :priority, only_integer: true, on: :create

  # Scopes
  scope :open,               -> { with_states(:open).order(priority: :desc, created_at: :desc) }
  scope :closed,             -> { with_states(:closed).order(closed_at: :desc) }
  scope :awaiting_manager,   -> { with_states(:awaiting_manager).order(:updated_at) }
  scope :awaiting_executive, -> { with_states(:awaiting_executive).order(:updated_at) }
  scope :archived,           -> { with_states(:archived).order(:updated_at) }
  scope :not_archived,       -> { without_states(:archived) }

  self.per_page = 15

  state_machine initial: :initialized do

    after_transition all => :awaiting_manager do
      puts "Awaiting manager approval."
    end

    after_transition all => :awaiting_executive do
      puts "Awaiting executive approval."
    end

    after_transition :open => :closed do
      puts "Closed from open."
    end

    after_transition :awaiting_executive => :closed do
      puts "Email finance."
    end

    event :set_state do
      transition [:initialized, :open] => :awaiting_manager, if: :has_purchases?
      transition [:awaiting_manager, :awaiting_executive] => :closed, if: :approving_executive
      transition :awaiting_manager => :awaiting_executive, if: :approving_manager
      transition :initialized => :open
    end

    # States
    state :initialized, human_name: 'Initialized'
    state :open, human_name: 'Open'
    state :awaiting_manager, human_name: 'Awaiting Manager Approval'
    state :awaiting_executive, human_name: 'Awaiting Executive Approval'
    state :closed, human_name: 'Closed'
    state :archived, human_name: 'Archived'
  end

  # Methods
  def priority_name
    PRIORITIES[priority].humanize
  end

  def manager_approved?
    approving_manager ? true : false
  end

  def executive_approved?
    approving_executive ? true : false
  end

  def disapprove
    approving_manager = nil
    manager_approved_at = nil
    approving_executive = nil
    executive_approved_at = nil
    locked = false
    closed = false
  end

  def has_purchases?
    purchases.count > 0 ? true : false
  end

  def total_items
    return 0 unless has_purchases?
    total = 0
    purchases.each do |item|
      total += item.quantity
    end
    return total
  end

  def total_cost
    return 0.0 unless has_purchases?
    total = 0.0
    purchases.each do |item|
      total += item.total
    end
    return total
  end

#  def can_close?
#    return unless has_purchases?
#    if approving_manager.nil?
#      errors.add(:closed, 'Tickets with purchases must be approved before they can be closed.')
#    end
#  end

  def flag_color
    case
    when state_name == :archived
      'navy'
    when state_name == :closed
      'green'
    when priority == PRIORITIES.index('urgent')
      'red'
    when priority == PRIORITIES.index('normal')
      'yellow'
    when priority == PRIORITIES.index('low')
      'blue'
    end
  end

  PRIORITIES.each_with_index do |meth, index|
    define_method("#{meth}?") { priority == index }
  end

#  def requires_approval?
#    if purchases_count == 0
#      return false
#    else
#      return true
#    end
#  end

#  def requires_manager_approval?
#    return false unless requires_approval?
#    if approving_manager_id == nil
#      return true
#    else
#      return false
#    end
#  end

#  def requires_executive_approval?
#    return false unless requires_approval?
#    if approving_manager_id != nil && approving_executive_id == nil
#      return true
#    else
#      return false
#    end
#  end

  private

  def send_notification
    ProjectMailer.new_ticket(self).deliver_later
  end

  # TODO: implement or remove
  def send_requires_approval_notification
    if purchase_count_changed? || approving_manager_id_changed?
      ProjectMailer.requires_approval(self).delivery_later
    end
  end

  def notify_assignee
    if assignee_id_changed? and assignee_id != nil
      TicketMailer.assignment_email(self).deliver_later
    end
  end
end
