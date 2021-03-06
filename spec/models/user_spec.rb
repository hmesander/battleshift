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

  describe 'Relationships' do
    it { should have_many(:games) }
  end

  describe 'Instance methods' do
    subject { create(:user) }

    it 'sends an email' do
      expect { Activator.inform(subject,'localhost:3000').deliver_now }
      .to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
