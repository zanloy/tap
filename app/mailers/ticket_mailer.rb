class TicketMailer < ApplicationMailer

  def assignment_email(ticket)
    @ticket = ticket
    @email = @ticket.assignee.email
    mail(to: @email, subject: "You have been assigned ticket ##{@ticket.id}")
  end

  def approval_email(ticket)
    @ticket = ticket
    @project = @ticket.project

    if not @ticket.approving_executive.nil?
      # Send email to finance
    elsif not @ticket.approving_manager.nil?
      send_to = @project.memberships.where(role: Membership.role_index(:executive))
    else
      # Send email to manager(s)
      send_to = @project.memberships.where(role: Membership.role_index(:manager))
    end

    unless send_to.nil?
      send_to.each do |user|
        mail(to: user.email, subject: "Ticket ##{@ticket.id} requires your approval.")
      end
    end
  end

end
