require 'rails_helper'

describe Space do
  context 'initialize' do
    it 'has valid attributes' do
      space = Space.new(['A1', 'A2'])

      expect(space.coordinates).to eq(['A1', 'A2'])
      expect(space.contents).to eq(nil)
      expect(space.status).to eq('Not Attacked')
    end
  end
  context 'instance methods' do
    let(:space) { Space.new(['A1', 'A2']) }
    it '.attack!' do
      space.attack!

      expect(space.status).to eq('Miss')
    end
    it '.occupy!' do
      ship = Ship.new(4)
      space.occupy!(ship)
      expect(space.contents).to eq(ship)
    end
    it '.occupied?' do
      expect(space.occupied?).to eq(false)
    end
    it '.not_attacked?' do
      expect(space.not_attacked?).to eq(true)
    end
  end
end
