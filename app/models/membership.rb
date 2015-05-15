class Membership < ActiveRecord::Base

  ROLES = %w[moderator worker manager executive admin]

  # Associations
  belongs_to :project
  belongs_to :user

  accepts_nested_attributes_for :user

  # Methods
  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

end
