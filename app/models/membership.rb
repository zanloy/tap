class Membership < ActiveRecord::Base

  ROLES = %w[member moderator worker manager executive]

  # Associations
  belongs_to :project
  belongs_to :user

  accepts_nested_attributes_for :user

  # Methods
  def role?(base_role)
    base_role = ROLES.index(base_role.to_s) if base_role.is_a? String or base_role.is_a? Symbol
    base_role <= role
  end

  def role_name
    return '' if role >= ROLES.count
    ROLES[role].humanize
  end

  def user_name
    self.user.name
  end

end
