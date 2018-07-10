require 'rails_helper'

describe User, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email_address) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:email_address) }
    it { should validate_presence_of(:token) }
    it { should validate_uniqueness_of(:token) }
  end

  describe 'Instance methods' do
    subject { create(:user) }

    it 'sends an email' do
      expect { subject.send_instructions }
      .to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
