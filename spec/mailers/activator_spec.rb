require 'rails_helper'

describe Activator, type: :mailer do
  describe '#inform(user)' do
    let(:user) { create(:user) }
    let(:mail) { described_class.inform(user, 'localhost:3000').deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Activate Account')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email_address])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@battleshift.com'])
    end

    it 'renders the user API token' do
      expect(mail.body).to include("API Key: #{user.token}")
    end
  end
end
