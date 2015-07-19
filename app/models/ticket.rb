class Ticket < ActiveRecord::Base

  PRIORITIES = %w[low normal urgent]

  after_create :send_notification
  after_save :notify_assignee

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
  validate :can_close?, if: :closed?

  # Scopes
  scope :open, -> { not_archived.where(closed: false).order(priority: :desc, created_at: :desc) }
  scope :closed, -> { not_archived.where(closed: true).order(closed_at: :desc) }
  scope :awaiting_manager, -> { open.where("purchases_count > 0").where(approving_manager_id: nil) }
  scope :awaiting_executive, -> { open.where("purchases_count > 0").where.not(approving_manager_id: nil).where(approving_executive_id: nil) }
  scope :archived, -> { where(archived: true) }
  scope :not_archived, -> { where(archived: false) }

  self.per_page = 15

  # Methods
  def priority_name
    PRIORITIES[priority].humanize
  end

  def status
    rtn = []
    rtn << 'Locked' if locked
    rtn << 'Closed' if closed
    rtn << 'Archived' if archived
    if rtn == []
      return 'Open'
    else
      return rtn.join(', ')
    end
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

  def locked?
    locked
  end

  def open?
    !closed
  end

  def closed?
    closed
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

  def can_close?
    return unless has_purchases?
    if approving_manager.nil?
      errors.add(:closed, 'Tickets with purchases must be approved before they can be closed.')
    end
  end

  def flag_color
    return 'navy' if archived
    return 'green' if closed
    return 'red' if priority == PRIORITIES.index('urgent')
    return 'yellow' if priority == PRIORITIES.index('normal')
    return 'blue' if priority == PRIORITIES.index('low')
  end

  PRIORITIES.each_with_index do |meth, index|
    define_method("#{meth}?") { priority == index }
  end

  def requires_approval?
    if purchases_count == 0
      return false
    else
      return true
    end
  end

  def requires_manager_approval?
    return false unless requires_approval?
    if approving_manager_id == nil
      return true
    else
      return false
    end
  end

  def requires_executive_approval?
    return false unless requires_approval?
    if approving_manager_id != nil && approving_executive_id == nil
      return true
    else
      return false
    end
  end

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
