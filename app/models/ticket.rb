class Ticket < ActiveRecord::Base

  PRIORITIES = %w[low normal urgent]

  after_create :send_notification

  # Associations
  belongs_to :project
  belongs_to :reporter, class_name: User
  belongs_to :assignee, class_name: User
  belongs_to :closed_by, class_name: User
  belongs_to :approving_manager, class_name: User
  belongs_to :approving_executive, class_name: User
  has_many :purchases
  has_many :comments

  accepts_nested_attributes_for :purchases, reject_if: :all_blank, allow_destroy: true

  # Validation
  validates_presence_of :project, :reporter, :priority, :title
  validates_numericality_of :priority, only_integer: true, on: :create
  validate :can_close?, if: :closed?

  # Scopes
  scope :open, -> { where(closed: false, archived: false) }
  scope :closed, -> { where(closed: true, archived: false) }
  scope :archived, -> { where(archived: true) }

  self.per_page = 15

  # Methods
  def priority_name
    PRIORITIES[priority].humanize
  end

  def status
    case
    when archived && closed then 'Closed and Archived'
    when closed then 'Closed'
    when archived then'Archived'
    else
      'Open'
    end
  end

  def manager_approved?
    if approving_manager
      return true
    else
      return false
    end
  end

  def executive_approved?
    if approving_executive
      return true
    else
      return false
    end
  end

  def locked?
    closed?
  end

  def has_purchases?
    if purchases.count > 0
      true
    else
      false
    end
  end

  def total_items
    return 0 unless has_purchases?
    total = 0
    purchases.each do |item|
      total += purchases.count
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

  def open?
    !closed
  end

  def closed?
    closed
  end

  def can_close?
    return unless has_purchases?
    if approving_executive.nil?
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

  private

  def send_notification
    #NewTicketNotificationJob.perform_later(self)
    ProjectMailer.new_ticket(self).deliver_later
  end

end
