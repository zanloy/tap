class Purchase < ActiveRecord::Base

  after_save :notify_parent

  STATUSES = %w[waiting approved rejected]

  # Associations
  belongs_to :ticket, counter_cache: true

  # Validations
  validates_presence_of :name, :quantity, :cost

  STATUSES.each do |meth|
    define_method("#{meth}?") { status == meth }
  end

  def total
    quantity * cost
  end

  def has_url?
    !url.nil? and !url.empty?
  end

  private

  def notify_parent
    ticket.set_approval_state
  end
  
end
