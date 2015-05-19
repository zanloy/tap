class Ticket < ActiveRecord::Base

  PRIORITIES = %w[low normal urgent]

  # Associations
  belongs_to :project
  belongs_to :submitter, class_name: User
  belongs_to :assignee, class_name: User
  has_many :comments

  # Validation
  validates_presence_of :project, :submitter, :priority, :title
  validates_numericality_of :priority, only_integer: true, on: :create

  # Scopes
  scope :unresolved, -> { where(resolved: false) }

  # Methods
  def priority_name
    PRIORITIES[priority].humanize
  end

  def status
    case
    when archived && resolved then 'Resolved and Archived'
    when resolved then 'Resolved'
    when archived then'Archived'
    else
      'Unresolved'
    end
  end

  def unresolved?
    !resolved
  end

  def flag_color
    return 'navy' if archived
    return 'green' if resolved
    return 'red' if priority == PRIORITIES.index('urgent')
    return 'yellow' if priority == PRIORITIES.index('normal')
    return 'blue' if priority == PRIORITIES.index('low')
  end

  PRIORITIES.each_with_index do |meth, index|
    define_method("#{meth}?") { priority == index }
  end

end
