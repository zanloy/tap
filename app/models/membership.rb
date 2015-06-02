class Membership < ActiveRecord::Base

  ROLES = %w[member worker moderator manager]

  # Associations
  belongs_to :project
  belongs_to :user

  accepts_nested_attributes_for :user

  # Validations
  validates_presence_of :project, :user

  # Methods
  def role?(base_role)
    base_role = ROLES.index(base_role.to_s) if base_role.is_a? String or base_role.is_a? Symbol
    base_role <= role
  end

  def self.role_index(role)
    ROLES.index role.to_s
  end

  def self.role_name(index)
    return if index >= ROLES.count
    ROLES[index].to_sym
  end

  def role_name
    return '' if role >= ROLES.count
    ROLES[role].humanize
  end

end
