require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'

class GameTest < Minitest::Test
  attr_reader :game

  def setup
    @game = Game.new
  end

  def test_game_class_exist
    assert_instance_of Game, game
  end

  def test_guess_begins_as_nil
    assert_nil game.guess
  end

  def test_guesses_begins_as_empty_array
    assert_equal [], game.guesses
  end

  def test_number_saves_guess_in_guesses_array
    game.number(4)
    assert_equal [4], game.guesses
  end

  def test_correct_game_information_is_returned
    game.number(2)
    assert_equal "You've made a total of 1 guess(s), 
      you're most recent guess was 2 and your guess was too low.", game.game_information
  end

  def test_correct_game_information_is_returned_with_two_numbers_added
    game.number(2)
    game.number(3)
    assert_equal "You've made a total of 2 guess(s), 
      you're most recent guess was 3 and your guess was too low.", game.game_information
  end
end