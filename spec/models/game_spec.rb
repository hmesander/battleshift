require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'Relationships' do
    it { should have_many(:users) }
  end
end
