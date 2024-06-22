require_relative '../lib/gameboard.rb'

describe Gameboard do
  subject(:gameboard) {described_class.new()}
  let(:columns) {gameboard.instance_variable_get(:@columns)}
  before do
    allow(gameboard).to receive(:puts)
  end
  describe '#create_board' do
    it 'creates an array housing the column arrays' do
      gameboard.instance_variable_set(:@columns,nil)
      expect{gameboard.create_board}.to change{gameboard.instance_variable_get(:@columns).class}.from(NilClass).to(Array)
      gameboard.create_board()
    end
    it 'creates the columns inside the array by the defined size' do
      gameboard.create_board(6,7)
      expect(gameboard.instance_variable_get(:@columns).length).to eq(7)
    end
    it 'places a number of spaces inside each column array' do  
      gameboard.create_board()
      column = gameboard.instance_variable_get(:@columns)[0]
      expect(column).to all(be_a(Space))
    end
  end
  describe "#place_disk" do
    describe 'if the column is empty' do
      it 'places a disk in the first slot of the column' do
        expect{gameboard.place_disk(0,"X",columns)}.to change{columns[0][0].filled?}.from(false).to (true)
      end
    end
    describe 'if the column is not empty' do
      describe 'if the first slot is filled' do
        it 'places the disk in second slot' do
          columns[1][0].fill("X")
          expect{gameboard.place_disk(1,"X",columns)}.to change{columns[1][1].filled?}.from(false).to (true)
        end
      end
      describe 'if the first 3 slots are filled' do
        before do
          columns[2][0].fill("X")
          columns[2][1].fill("X")
          columns[2][2].fill("X")
        end
        it 'places the disk in fourth slot' do
          expect{gameboard.place_disk(2,"X",columns)}.to change{columns[2][3].filled?}.from(false).to (true)
        end
      end
      describe 'if the column is full' do
        before do
          columns[4][0].fill("X")
          columns[4][1].fill("X")
          columns[4][2].fill("X")
          columns[4][3].fill("X")
          columns[4][4].fill("X")
          columns[4][5].fill("X")
        end
        it 'returns and error' do
          expect(gameboard.place_disk(4,"X",columns)).to eq("Erorr: column is full")
        end
      end
    end
  end
  describe 'win?' do
    describe 'when there is a win' do
      describe 'if there is a horizontal win' do
        before do 
          columns[1][0].fill("X")
          columns[2][0].fill("X")
          columns[3][0].fill("X")
          columns[4][0].fill("X")
          gameboard.instance_variable_set(:@columns,columns)
        end
        it 'returns true' do
          last_move = columns[1][0]
          result = gameboard.win?(last_move)
          expect(result).to eq(true)
        end
      end
      describe 'if there is a vertical win' do
        before do 
          columns[5][2].fill("X")
          columns[5][3].fill("X")
          columns[5][4].fill("X")
          columns[5][5].fill("X")
          gameboard.instance_variable_set(:@columns,columns)
        end
        it 'returns true' do
          last_move = columns[5][5]
          result = gameboard.win?(last_move)
          expect(result).to eq(true)
        end
      end
      describe 'if there is a left diagonal win' do
        before do
          columns[2][4].fill("X")
          columns[3][3].fill("X")
          columns[4][2].fill("X")
          columns[5][1].fill("X")
          gameboard.instance_variable_set(:@columns,columns)
        end
        it 'returns true' do
          last_move = columns[3][3]
          result = gameboard.win?(last_move)
          expect(result).to eq(true)
        end
      end
      describe 'if there is a right diagonal win' do
        before do
          columns[0][2].fill("X")
          columns[1][3].fill("X")
          columns[2][4].fill("X")
          columns[3][5].fill("X")
          gameboard.instance_variable_set(:@columns,columns)
        end
        it 'returns true' do
          last_move = columns[3][5]
          result = gameboard.win?(last_move)
          expect(result).to eq(true)
        end
      end
    end
    describe 'when there isnt a win' do
      before do
        columns[0][0].fill("X")
        columns[0][1].fill("X")
        columns[0][2].fill("X")

        columns[1][1].fill("X")
        columns[2][1].fill("X")

        columns[2][2].fill("X")
        gameboard.instance_variable_set(:@columns,columns)
      end
      it 'returns false' do
        last_move = columns[2][2]
        result = gameboard.win?(last_move)
        expect(result).to eq(false)
      end
    end
  end
end
