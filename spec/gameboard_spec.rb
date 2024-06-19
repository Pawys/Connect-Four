require_relative '../lib/gameboard.rb'

describe Gameboard do
  subject(:gameboard) {described_class.new()}
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
    let(:columns) {gameboard.instance_variable_get(:@columns)}
    describe 'if player chooses first column' do
      describe 'if the column is empty' do
        it 'places a disk in the first slot of the column' do
          expect{gameboard.place_disk(0,"X",columns)}.to change{columns[0][0].filled?}.from(false).to (true)
        end
      end
      describe 'if the column is not empty' do
        describe 'if the first slot is filled' do
          it 'places the disk in second slot' do
            columns[0][0].fill("X")
            expect{gameboard.place_disk(0,"X",columns)}.to change{columns[0][1].filled?}.from(false).to (true)
          end
        end
        describe 'if the first 3 slots are filled' do
          before do
            columns[0][0].fill("X")
            columns[0][1].fill("X")
            columns[0][2].fill("X")
          end
          it 'places the disk in fourth slot' do
            expect{gameboard.place_disk(0,"X",columns)}.to change{columns[0][3].filled?}.from(false).to (true)
          end
        end
        describe 'if the column is full' do
          before do
            columns[0][0].fill("X")
            columns[0][1].fill("X")
            columns[0][2].fill("X")
            columns[0][3].fill("X")
            columns[0][4].fill("X")
            columns[0][5].fill("X")
          end
          it 'returns and error' do
            expect(gameboard.place_disk(0,"X",columns)).to eq("Erorr: column is full")
          end
        end
      end
    end
    describe 'if player chooses second column' do 
      describe 'if the column is empty' do
        it 'places a disk in the first slot of the column' do
          expect{gameboard.place_disk(1,"X",columns)}.to change{columns[1][0].filled?}.from(false).to (true)
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
            columns[1][0].fill("X")
            columns[1][1].fill("X")
            columns[1][2].fill("X")
          end
          it 'places the disk in fourth slot' do
            expect{gameboard.place_disk(1,"X",columns)}.to change{columns[1][3].filled?}.from(false).to (true)
          end
        end
      end
    end
  end
  describe '#check_win' do
    let(:columns) {gameboard.instance_variable_get(:@columns)}
    describe 'checks horizontal win' do
      describe 'if there is a horizontal win' do
          before do
            columns[0][0].fill()
            columns[1][0].fill()
            columns[2][0].fill()
            columns[3][0].fill()
          end
        describe 'if there are 3 same color disks to the right' do
          it 'returns true' do
            last_move = columns[0][0]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(true)
          end
        end
        describe 'if there are 2 same color to the right and one to the left' do
          it 'returns true' do
            last_move = columns[1][0]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(true)
          end
        end
        describe 'if there are 2 same color to the left and one to the right' do
          it 'returns true' do
            last_move = columns[2][0]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(true)
          end
        end
        describe 'if there are 3 same color to the left' do
          it 'returns true' do
            last_move = columns[3][0]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(true)
          end
        end
      end
      describe 'when there is no win' do
        describe 'when there are only two to the right' do
          before do
            columns[0][0].fill()
            columns[1][0].fill()
            columns[2][0].fill()
          end
          it 'returns false' do
            last_move = columns[0][3]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(false)
          end
        end
        describe 'when there are only two to the left' do
          before do
            columns[0][0].fill()
            columns[1][0].fill()
            columns[2][0].fill()
          end
          it 'returns false' do
            last_move = columns[2][0]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(false)
          end
        end
        describe 'when there is one two the right' do
          before do
            columns[0][0].fill()
            columns[1][0].fill()
          end
          it 'returns false' do
            last_move = columns[0][0]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(false)
          end
        end
        describe 'when there is one two the left' do
          before do
            columns[0][0].fill()
            columns[1][0].fill()
          end
          it 'returns false' do
            last_move = columns[1][0]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(false)
          end
        end
        describe 'when there is one to the left and right' do
          before do
            columns[0][0].fill()
            columns[1][0].fill()
            columns[2][0].fill()
          end
          it 'returns false' do
            last_move = columns[1][0]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(false)
          end
        end
        describe 'when there are no spaces on the left or right' do
          before do
            columns[0][0].fill()
          end
          it 'returns false' do
            last_move = columns[0][0]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(false)
          end
        end
      end
    end
    describe 'check vertical win' do
      describe 'when there is a win' do
        before do
          columns[0][0].fill
          columns[0][1].fill
          columns[0][2].fill
          columns[0][3].fill
        end
        it 'returns true' do
          last_move = columns[0][3]

          result = gameboard.check_win(last_move,columns)

          expect(result).to eq(true)
        end
      end
      describe 'when there isnt a win' do
        describe 'when there are only three filled spaces' do
          before do
            columns[0][1].fill
            columns[0][2].fill
            columns[0][3].fill
          end
          it 'returns false' do
            last_move = columns[0][3]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(false)
          end
        end
        describe 'when there are only two filled spaces' do
          before do
            columns[0][2].fill
            columns[0][3].fill
          end
          it 'returns false' do
            last_move = columns[0][3]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(false)
          end
        end
        describe 'when there is only filled space' do
          before do
            columns[0][3].fill
          end
          it 'returns false' do
            last_move = columns[0][3]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(false)
          end
        end
      end
    end
    describe 'checks for a diagonal win' do
      describe 'when there isnt a win' do
        describe 'when there are only 3 diagonals filled' do
          before do
            columns[0][3].fill
            columns[1][2].fill
            columns[2][1].fill
          end
          it 'returns false' do
            last_move = columns[0][3]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(false)
          end
        end
        describe 'when there are only 2 diagonals filled' do
          before do
            columns[0][3].fill
            columns[1][2].fill
          end
          it 'returns false' do
            last_move = columns[0][3]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(false)
          end
        end
        describe 'when there is only one diagonal filled' do
          before do
            columns[0][3].fill
          end
          it 'returns false' do
            last_move = columns[0][3]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(false)
          end
        end
        describe 'when there is none diagonals filled' do
          it 'returns false' do
            last_move = columns[0][3]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(false)
          end
        end
      end
      describe 'when there is a diagonal win' do
        describe 'when there is a left diagonal win' do
          before do
            columns[0][3].fill
            columns[1][2].fill
            columns[2][1].fill
            columns[3][0].fill
          end
          describe 'when the last move is at the top of the diagonal' do
            it 'returns true' do
            last_move = columns[0][3]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(true)
            end
          end
          describe 'when the last move is at the right of center of the diagonal' do
            it 'returns true' do
            last_move = columns[2][1]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(true)
            end
          end
          describe 'when the last move is at the left of center of the diagonal' do
            it 'returns true' do
            last_move = columns[1][2]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(true)
            end
          end
          describe 'when the last move is at the bottom of the diagonal' do
            it 'returns true' do
            last_move = columns[3][0]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(true)
            end
          end
        end
        describe 'when there is a right diagonal win' do
          before do
            columns[0][0].fill
            columns[1][1].fill
            columns[2][2].fill
            columns[3][3].fill
          end
          describe 'when the last move is at the end of the diagonal' do
            it 'returns true' do
            last_move = columns[3][3]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(true)
            end
          end
          describe 'when the last move is at the right of center of the diagonal' do
            it 'returns true' do
            last_move = columns[2][2]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(true)
            end
          end
          describe 'when the last move is at the left of center of the diagonal' do
            it 'returns true' do
            last_move = columns[1][1]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(true)
            end
          end
          describe 'when the last move is at the bottom of the diagonal' do
            it 'returns true' do
            last_move = columns[0][0]

            result = gameboard.check_win(last_move,columns)

            expect(result).to eq(true)
            end
          end
        end
      end
    end
  end
end
