class Project < ActiveRecord::Base

  # Associations
  belongs_to :owner, class_name: User

  # Validation
  validates_presence_of :name
  validates_uniqueness_of :name

  # Scopes
  scope :not_private, -> { where(private: false) }

end
