class TicketMailer < ApplicationMailer

  def assignment_email(ticket)
    @ticket = ticket
    @email = @ticket.assignee.email
    mail(to: @email, subject: "You have been assigned ticket ##{@ticket.id}")
  end

  def approval_email(ticket)
    return false if ticket.closed? or !ticket.has_purchases?
    @ticket = ticket

    if @ticket.manager_approved?
      send_to = User.where(executive: true)
    else
      send_to = @project.memberships.where(role: Membership.role_index(:manager))
    end

    unless send_to.nil?
      send_to.each do |user|
        mail(to: user.email, subject: "Ticket ##{@ticket.id} requires your approval.")
      end
    end
  end

  def finance_email(ticket)
    @ticket = ticket
    mail(to: 'finance@sparcedge.com', subject: "Ticket ##{@ticket.id} has been approved for purchase.")
  end

end
