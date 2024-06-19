require_relative '../lib/space.rb'

describe Space do
  subject(:space) {described_class.new(0,0)}
  describe '#filled?' do
    describe 'when it is filled' do
      it 'returns true' do
        space.instance_variable_set(:@filled, true)
        result = space.filled?
        expect(result).to eq(true)
      end
    end
    describe 'when it is not filled' do
      it 'returns false' do
        space.instance_variable_set(:@filled, false)
        result = space.filled?
        expect(result).to eq(false)
      end
    end
  end
  describe "fill" do
    it 'changes filled to true' do
      space.instance_variable_set(:@filled,false)
      expect{space.fill("red")}.to change{space.instance_variable_get(:@filled)}.from(false).to (true)
    end
    it 'changes disk color to the given color' do
      space.instance_variable_set(:@disk_sign,"blue")
      expect{space.fill("red")}.to change{space.instance_variable_get(:@disk_sign)}.from("blue").to ("red")
    end
  end
end
