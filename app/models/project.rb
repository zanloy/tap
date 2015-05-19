class Project < ActiveRecord::Base

  # Associations
  belongs_to :owner, class_name: User
  has_many :memberships
  has_many :users, through: :memberships
  has_many :tickets

  accepts_nested_attributes_for :memberships, allow_destroy: true
  accepts_nested_attributes_for :users

  # Validation
  validates_presence_of :name
  validates_uniqueness_of :name

  # Scopes
  scope :show_in_navbar, -> { where(show_in_navbar: true) }
  scope :not_private, -> { where(private: false) }

  # Methods
  def user_role?(user)
    self.memberships.first(user_id: user.id).role
  end

  def workers
    self.memberships.where('role >= 1').order(:role)
  end
end