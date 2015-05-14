class Ticket < ActiveRecord::Base

  PRIORITIES = %w[info low normal urgent immediate]
  STATUSES = %w[submitted assigned resolved rejected]

  # Associations
  belongs_to :project
  belongs_to :submitter, class_name: User
  belongs_to :worker, class_name: User

  # Validation
  validates_presence_of :project, :submitter, :priority, :title
  validates_numericality_of :priority, only_integer: true, on: :create

  # Scopes
  scope :unresolved, -> { where(status: 'submitted') }

  # Methods
  def priority_name
    PRIORITIES[priority].humanize
  end

  PRIORITIES.each_with_index do |meth, index|
    define_method("#{meth}?") { priority == index }
  end

  STATUSES.each_with_index do |meth, index|
    define_method("#{meth}?") { status == index }
  end

end
