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

    # Public things.
    can :read, User, id: user.id
    can [:read, :closed], Project, private: false
    can [:new, :create, :subscribe, :unsubscribe], Ticket
    can [:read], Ticket, reporter: user

    # Admin stuff.
    if user.role? :manager
      can :manage, Project
    end
    if user.role? :admin
      can :manage, :all
    end
    if user.executive
      can [:approve, :executive_approve], Ticket, state_name: [:awaiting_manager, :awaiting_executive]
    end

    # User's can control their own destiny!
    can [:edit, :update, :close], Ticket, reporter: user, state_name: [:unassigned, :assigned, :awaiting_manager]
    can :reopen, Ticket, reporter: user, closed_by: user, state_name: :closed
    can :destroy, Comment, user: user

    # Membership has it's benefits.
    user.memberships.each do |membership|
      if membership.role? :worker
        can :read, Ticket, project: membership.project
        can :close, Ticket, project: membership.project, state_name: :assigned, assignee: user
        can :self_assign, Ticket, project: membership.project, state_name: [:unassigned, :assigned]
        cannot :self_assign, Ticket, project: membership.project, state_name: :assigned, assignee: user
        can :reopen, Ticket, project: membership.project, state_name: :closed, closed_by: user
      end
      if membership.role? :moderator
        can [:update, :edit, :moderate, :close, :destroy], Ticket, project: membership.project, state_name: [:unassigned, :assigned, :awaiting_manager]
        can :reopen, Ticket, project: membership.project, state_name: :closed
      end
      if membership.role? :manager
        can :manage, Project, id: membership.project.id
        can [:update, :edit, :moderate, :close, :destroy], Ticket, project: membership.project, state_name: :awaiting_executive
        can [:approve,:manager_approve], Ticket, project: membership.project, state_name: :awaiting_manager
      end
    end
  end
end
