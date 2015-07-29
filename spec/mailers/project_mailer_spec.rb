require "rails_helper"

RSpec.describe ProjectMailer, type: :mailer do
  let(:project) { create(:project, name: 'Testing', notification_email: 'test@test.com')}
  let(:ticket) { create(:ticket, project: project) }
  let(:mail) { ProjectMailer.new_ticket(ticket) }
  describe '#new_ticket' do
    it 'renders the subject' do
      expect(mail.subject).to eql('New Ticket in Testing')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql(['test@test.com'])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['tap@sparcedge.com'])
    end

    describe 'email body' do
      subject { mail.body.encoded }
      it { is_expected.to have_content("The following new ticket has been added to Testing.")}
      #it { is_expected.to render_template 'ticket_mailer/details' }
    end

  end
end
