require_relative 'player.rb'
class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @name1 = Player.new(name1,1)
    @name2 = Player.new(name2,2)
    @cups = Array.new(14) {Array.new}
    @current_player = @name1.name
    place_stones
  end

  def place_stones
    stone = :stone
    @cups.take(6).map{|cup| 4.times{cup<<stone}}
    @cups[7..12].map{|cup| 4.times{cup<<stone}}
    # helper method to #initialize every non-store cup with four stones each
  end

  def valid_move?(start_pos)
    raise 'Invalid starting cup' if !start_pos.between?(0,13)
    raise 'Starting cup is empty' if @cups[start_pos].empty?
    true
  end

  def make_move(start_pos, current_player_name)
    stones = @cups[start_pos]
    @cups[start_pos] = []

    cup_idx = start_pos
    until stones.empty?
      cup_idx+=1
      cup_idx = 0 if cup_idx > 13
      if cup_idx == 6
        @cups[6] << stones.pop if current_player_name == @name1.name
      elsif cup_idx == 13
        @cups[13] << stones.pop if current_player_name == @name2.name
      else
        @cups[cup_idx] << stones.pop
      end
    end
    render
    # return :prompt if cup_idx == 6 || cup_idx == 13
    # return :switch if @cups[cup_idx].size == 1
    next_turn(cup_idx)
  end

  def next_turn(ending_cup_idx)
    return :prompt if ending_cup_idx == 6 || ending_cup_idx == 13
    return :switch if @cups[ending_cup_idx].size == 1
    return ending_cup_idx if !@cups[ending_cup_idx].empty?
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    return true if @cups[0..5].all? {|cup| cup.empty?} || @cups[7..12].all? {|cup| cup.empty?}
    false
  end

  def winner
    if @cups[6].size > @cups[13].size
      p "#{@name1.name}"
    elsif @cups[6].size == @cups[13].size
      p :draw
    else
      p "#{@name2.name}"
    end
  end
end
