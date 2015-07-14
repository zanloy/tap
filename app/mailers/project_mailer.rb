class ProjectMailer < ApplicationMailer

  def new_ticket(ticket)
    return unless ticket.project.notification_email
    @ticket = ticket
    @reporter = @ticket.reporter
    @project = @ticket.project
    email = @ticket.project.notification_email
    mail(to: email, subject: "New Ticket in #{@project.name}")
  end

end
