class User < ActiveRecord::Base

  ROLES = %w[user manager admin]

  # Associations
  has_many :memberships
  has_many :projects, through: :memberships
  has_many :tickets, foreign_key: :reporter_id
  has_many :comments
  has_many :subscriptions, dependent: :delete_all

  # Validation
  validates_presence_of :email, :name
  validates_uniqueness_of :email, :name

  # Scopes
  scope :sorted, -> { order(:name) }

  def role?(base_role)
    ROLES.index(base_role.to_s) <= role
  end

  def self.from_omniauth(auth)
    # Validate the only omniauth logins are allowed from sparcedge.com
    if auth.info.email.split('@')[1] != 'sparcedge.com'
      redirect_to signin_path, alert: 'You must use an @sparcedge.com for Google Auth login.'
    end
    where(email: auth.info.email).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def name_or_email
    return name unless name.nil?
    return email
  end

end
