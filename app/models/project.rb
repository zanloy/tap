class Project < ActiveRecord::Base

  # Associations
  belongs_to :owner, class_name: User
  has_many :memberships
  has_many :users, through: :memberships
  has_many :tickets, dependent: :delete_all

  accepts_nested_attributes_for :memberships, allow_destroy: true
  accepts_nested_attributes_for :users

  # Validation
  validates_presence_of :name
  validates_uniqueness_of :name

  # Scopes
  scope :show_in_navbar, -> { where(show_in_navbar: true).order(:name) }
  scope :not_private,    -> { where(private: false) }

  # Methods
  def user_role?(user)
    memberships.where(user_id: user.id).pluck(:role).first
  end

  def workers
    memberships.where('role >= 1').order(:role)
  end

  def managers
    memberships.where(role: 3)
  end
end
