class TicketMailer < ApplicationMailer

  def approval_email(ticket)
    @ticket = ticket

    if @ticket.state_name == :awaiting_executive
      send_to = User.where(executive: true)
    elsif @ticket.state_name == :awaiting_manager
      manager_ids = @ticket.project.memberships.where(role: Membership.role_index(:manager)).pluck(:user_id)
      send_to = User.where(id: manager_ids)
    end

    unless send_to.nil?
      mail(to: send_to.pluck(:email), subject: "Ticket ##{@ticket.id} requires approval.")
    end
  end

  def assignment_email(ticket)
    @ticket = ticket
    @email = @ticket.assignee.email
    mail(to: @email, subject: "You have been assigned ticket ##{@ticket.id}")
  end

  def closed_email(ticket)
    @ticket = ticket
    mail(to: @ticket.reporter.email, subject: "Ticket #{@ticket.id} has been closed.")
  end

  def finance_email(ticket)
    @ticket = ticket
    mail(to: 'finance@sparcedge.com', subject: "Ticket ##{@ticket.id} has been approved for purchase.")
  end

end
