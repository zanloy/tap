class Ticket < ActiveRecord::Base

  PRIORITIES = %w[low normal urgent]

  # Associations
  belongs_to :project
  belongs_to :reporter, class_name: User
  belongs_to :assignee, class_name: User
  has_many :purchases
  has_many :comments

  accepts_nested_attributes_for :purchases, allow_destroy: true

  # Validation
  validates_presence_of :project, :reporter, :priority, :title
  validates_numericality_of :priority, only_integer: true, on: :create

  # Scopes
  scope :open, -> { where(closed: false, archived: false) }
  scope :closed, -> { where(closed: true, archived: false) }
  scope :archived, -> { where(archived: true) }

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

  def has_purchases?
    if purchases.count > 0
      true
    else
      false
    end
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

end
