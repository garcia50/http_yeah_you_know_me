class Game
  attr_reader :guesses, :answer, :guess

  def initialize
    @answer = rand(1..100)
    @guesses = []
    @guess = nil
  end

  def number(user_guess)
    @guess = user_guess.to_i
    guesses << guess
  end

  def guess_monitor
    if guess == answer
      "Correct!"
    elsif guess < answer
      "too low."
    elsif guess > answer
      "too high."
    end
  end

  def game_information
    "You've made a total of #{guesses.count} guess(s), 
      you're most recent guess was #{guesses.last} and your guess was #{guess_monitor}" 
  end
end

# "/", "hello", "datetime", "shutdown", "word_search",
#   "game", "start_game", "force_error"