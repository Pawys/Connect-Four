require_relative '../lib/gameboard.rb'

describe Gameboard do
  subject(:gameboard) {described_class.new()}
  describe '#create_board' do
    it 'creates an array housing the column arrays' do
      gameboard.instance_variable_set(:@columns,nil)
      expect{gameboard.create_board}.to change{gameboard.instance_variable_get(:@columns).class}.from(NilClass).to(Array)
      gameboard.create_board()
    end
    it 'creates the columns inside the array by the defined size' do
      gameboard.create_board(7,6)
      expect(gameboard.instance_variable_get(:@columns).length).to eq(7)
    end
    it 'places a number of spaces inside each column array' do  
      gameboard.create_board()
      column = gameboard.instance_variable_get(:@columns)[0]
      expect(column).to all(be_a(Space))
    end
  end
end
