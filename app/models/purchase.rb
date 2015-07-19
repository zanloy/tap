class Purchase < ActiveRecord::Base

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

end
