require_relative '../lib/connect_four'

describe ConnectFour do
  subject(:connect_four) {described_class.new(gameboard)}
  let(:gameboard) {instance_double(Gameboard)}
  before do
    allow(connect_four).to receive(:puts)
    allow(connect_four).to receive(:system)
    allow(gameboard).to receive(:draw)
    allow(gameboard).to receive(:column_full?)
  end

  describe '#switch_player' do 
    let(:player_one) {connect_four.instance_variable_get(:@player_one)}
    let(:player_two) {connect_four.instance_variable_get(:@player_two)}

    describe 'when the player is @player_one' do
      it 'sets the current player to @player_two' do
        connect_four.instance_variable_set(:@current_player,player_one)

        expect{connect_four.switch_player}.to change{connect_four.instance_variable_get(:@current_player)}.from(player_one).to (player_two)
      end
    end
    describe 'when the player is @player_two' do
      it 'sets the current player to @player_one' do
        connect_four.instance_variable_set(:@current_player,player_two)

        expect{connect_four.switch_player}.to change{connect_four.instance_variable_get(:@current_player)}.from(player_two).to (player_one)
      end
    end
    describe 'when the player is nil' do
      it 'sets the current player to @player_one' do
        connect_four.instance_variable_set(:@current_player,nil)

        expect{connect_four.switch_player}.to change{connect_four.instance_variable_get(:@current_player)}.from(nil).to (player_one)
      end
    end
  end
  describe '#get_num_input' do
    describe 'when the user enters correct input' do
      before do
        allow(connect_four).to receive(:gets).and_return("1")
      end
      it 'returns the input of the user' do
        result = connect_four.get_num_input()
        expect(result).to eq(1)
      end
    end
    describe 'when the user enters incorrect input' do
      before do
        allow(connect_four).to receive(:gets).and_return("123","1")
      end
      it 'asks the user to enter the input again and then returns the input' do
        result = connect_four.get_num_input()
        expect(result).to eq(1)
      end
    end
  end
  describe '#get_string_input' do
    describe 'when the user enters correct input' do
      before do
        allow(connect_four).to receive(:gets).and_return("y")
      end
      it 'returns the input of the user' do
        result = connect_four.get_string_input('y','n',"y/n")
        expect(result).to eq('y')
      end
    end
    describe 'when the user enters incorrect input' do
      before do
        allow(connect_four).to receive(:gets).and_return("3","n")
      end
      it 'asks the user to enter the input again and then returns the input' do
        result = connect_four.get_string_input('y','n',"y/n")
        expect(result).to eq('n')
      end
    end
  end
  describe '#place_disk' do
    before do
      connect_four.instance_variable_set(:@current_player,connect_four.instance_variable_get(:@player_one))
      allow(connect_four).to receive(:get_num_input).and_return(6)
    end
    it 'executes the place disk function with the correct paramaters' do
      expect(gameboard).to receive(:place_disk).with(5,connect_four.instance_variable_get(:@current_player).disk)
      connect_four.place_disk()
    end
    describe 'when the chosen column is full' do
      before do
        allow(connect_four).to receive(:get_num_input).and_return(6,5)
        allow(gameboard).to receive(:column_full?).and_return(true,false)
        allow(gameboard).to receive(:place_disk)
      end
      it 'asks for input again' do
        expect(connect_four).to receive(:get_num_input).twice
        connect_four.place_disk()
      end
    end
  end
  describe '#game_end?' do
    describe 'if there is a tie' do
      before do
        allow(gameboard).to receive(:tie?).and_return(true)
        allow(gameboard).to receive(:win?).and_return(false)
      end
      it 'returns true' do
        result = connect_four.game_end?
        expect(result).to eq(true)
      end
    end
    describe 'if there is a win' do
      before do
        allow(gameboard).to receive(:tie?).and_return(false)
        allow(gameboard).to receive(:win?).and_return(true)
      end
      it 'returns true' do
        result = connect_four.game_end?
        expect(result).to eq(true)
      end
    end
    describe 'if there is not a win or tie' do
      before do
        allow(gameboard).to receive(:tie?).and_return(false)
        allow(gameboard).to receive(:win?).and_return(false)
      end
      it 'returns true' do
        result = connect_four.game_end?
        expect(result).to eq(false)
      end
    end
  end
  describe '#end_game' do
    before do
      allow(connect_four).to receive(:get_string_input)
    end
    describe 'when the game ended in a tie' do
      before do
        allow(gameboard).to receive(:tie?).and_return(true)
      end
      it 'sends the tie message' do
        message = "The game ended in a tie."
        expect(connect_four).to receive(:puts).with(message)
        connect_four.end_game()
      end
    end
    describe 'when the game ended in a win' do
      before do
        allow(gameboard).to receive(:tie?).and_return(false)
      end
      it 'sends the win message' do
        current_player = connect_four.instance_variable_get(:@current_player)
        message = "#{current_player.name} won the game!"
        expect(connect_four).to receive(:puts).with(message)
        connect_four.end_game()
      end
    end
    describe 'when the user inputs y' do
      before do
        allow(gameboard).to receive(:tie?).and_return(false)
        allow(connect_four).to receive(:get_string_input).and_return('y')
        allow(connect_four).to receive(:reset)
        allow(connect_four).to receive(:play)
      end
      it 'calls the reset function' do
        expect(connect_four).to receive(:reset)
        connect_four.end_game()
      end
      it 'calls the play function' do
        expect(connect_four).to receive(:play)
        connect_four.end_game()
      end
    end
  end
  describe '#reset' do
    before do
      allow(gameboard).to receive(:create_board)
      allow(connect_four).to receive(:play)
    end
    it 'creates a new board' do
      expect(gameboard).to receive(:create_board)
      connect_four.reset()
    end
    it 'resets the current_player' do
      connect_four.instance_variable_set(:@current_player,connect_four.instance_variable_get(:@player_two))
      expect{connect_four.reset()}.to change{connect_four.instance_variable_get(:@current_player)}.to(connect_four.instance_variable_get(:@player_one))
    end
  end
end
