class Attachment < ActiveRecord::Base

  has_attached_file :file

  # Associations
  belongs_to :ticket, counter_cache: true

  # Validations
  validates :ticket, presence: true
  validates_attachment :file, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/gif', 'image/png', 'application/pdf'] }

end
