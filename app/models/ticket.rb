class Ticket < ActiveRecord::Base

  PRIORITIES = %w[low normal urgent]

  after_create :send_notification
  after_save :set_approval_state, :check_if_unassigned

  # Associations
  belongs_to :project
  belongs_to :reporter, class_name: User
  belongs_to :assignee, class_name: User
  belongs_to :closed_by, class_name: User
  belongs_to :approving_manager, class_name: User
  belongs_to :approving_executive, class_name: User
  has_many :purchases, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :subscriptions, dependent: :delete_all

  accepts_nested_attributes_for :purchases, reject_if: :all_blank, allow_destroy: true

  # Validation
  validates_presence_of :project, :reporter, :priority, :title
  validates_numericality_of :priority, only_integer: true, on: :create

  # Scopes
  scope :open,               -> { with_states([:unassigned, :assigned]).order(priority: :desc, created_at: :desc) }
  scope :closed,             -> { with_states(:closed).order(closed_at: :desc) }
  scope :awaiting_manager,   -> { with_states(:awaiting_manager).order(:updated_at) }
  scope :awaiting_executive, -> { with_states(:awaiting_executive).order(:updated_at) }
  scope :archived,           -> { with_states(:archived).order(:updated_at) }
  scope :not_archived,       -> { without_states(:archived) }

  self.per_page = 15

  state_machine initial: :unassigned do

    # Dealing with the :assigned state
    before_transition any => :assigned do |ticket, transition|
      if ticket.assignee.nil?
        ticket.assignee = transition.args.first or return false
      end
    end

    after_transition any => :assigned do |ticket, transition|
      TicketMailer.assignment_email(ticket).deliver_later
    end

    # Dealing with the :awaiting_manager state
    after_transition all => :awaiting_manager do |ticket|
      TicketMailer.approval_email(ticket).deliver_later
    end

    # Dealing with the :awaiting_executive state
    before_transition :awaiting_manager => :awaiting_executive do |ticket, transition|
      ticket.approving_manager = transition.args.first or return false
      ticket.manager_approved_at = Time.zone.now
    end

    after_transition all => :awaiting_executive do |ticket|
      TicketMailer.approval_email(ticket).deliver_later
    end

    # Dealing with the :closed state
    before_transition [:awaiting_manager, :awaiting_executive] => :closed do |ticket, transition|
      return false if transition.args.first == nil
      if transition.from.to_sym == :awaiting_manager
        ticket.approving_manager = transition.args.first
        ticket.manager_approved_at = Time.zone.now
      end
      ticket.approving_executive = transition.args.first
      ticket.executive_approved_at = Time.zone.now
    end

    after_transition [:awaiting_manager, :awaiting_executive] => :closed do |ticket|
      TicketMailer.finance_email(ticket).deliver_later
    end

    before_transition any => :closed do |ticket, transition|
      ticket.closed_by = transition.args.first or return false
      ticket.closed_at = Time.zone.now
      TicketMailer.closed_email(ticket).deliver_later
    end

    before_transition :closed => any - [:archived] do |ticket|
      ticket.closed_by = nil
      ticket.closed_at = nil
    end

    event :unassign do
      transition :assigned => :unassigned
    end

    event :assign_to do
      transition any => :assigned
    end

    event :request_manager_approval do
      transition [:unassigned, :assigned] => :awaiting_manager
    end

    event :manager_approve do
      transition :awaiting_manager => :awaiting_executive
    end

    event :executive_approve do
      transition [:awaiting_manager, :awaiting_executive] => :closed
    end

    event :close do
      transition [:unassigned, :assigned] => :closed, unless: :has_purchases?
      transition :awaiting_executive => :closed
    end

    event :reopen do
      transition :closed => :assigned, if: :assignee
      transition :closed => :unassigned
    end

    # States
    state :unassigned
    state :assigned
    state :awaiting_manager
    state :awaiting_executive
    state :closed
    state :archived
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
    purchases_count > 0 ? true : false
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

  def check_if_unassigned
    unassign if state_name == :assigned and assignee.nil?
  end

  def set_approval_state
    if has_purchases?
      request_manager_approval if approving_manager.nil?
    else
      approving_manager = nil
      manager_approved_at = nil
      approving_executive = nil
      executive_approved_at = nil
      if assignee
        state = :assigned
      else
        state = :unassigned
      end
    end
  end

  private

  def send_notification
    ProjectMailer.new_ticket(self).deliver_later
  end

end
