class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    can :read, [Project, Ticket]
    if user.role? :manager
      can :create, Project
    end
    if user.role? :admin
      can :manage, :all
    end

    user.tickets.open.each do |ticket|
      can :edit, ticket
      can :close, ticket
    end

    user.memberships.each do |membership|
      if membership.role? :worker
        can :work, Ticket, project: membership.project
      end
      if membership.role? :moderator
        can :moderate, Ticket, project: membership.project
        can :close, Ticket, project: membership.project
        can :delete, Ticket, project: membership.project
      end
      if membership.role? :manager
        can :manage, membership.project
        can :approve, Ticket, project: membership.project, has_purchases?: true
        can :manager_approve, Ticket, project: membership.project
      end
      if membership.role? :executive
        can :executive_approve, Ticket, project: membership.project
      end
    end
  end

end
