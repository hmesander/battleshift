require 'rails_helper'

describe Activator, type: :mailer do
  describe '#inform(user)' do
    let(:user) { create(:user) }
    let(:mail) { described_class.inform(user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Activate Account')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email_address])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@battleshift.com'])
    end
  end
end
