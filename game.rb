class Game
  attr_reader :guesses, :answer, :guess

  def initialize
    @answer = rand(1..100)
    @guesses = []
    @guess = nil
  end

  def guess_monitor(user_guess)
    @guess = user_guess
    guesses << guess
    if guess == answer
      "Correct!"
    elsif guess < answer
      "too low."
    elsif guess > answer
      "too high."
    end
  end

  def game_information
    outcome = guess_monitor(guess)
    "You've made a total of #{guesses.count}, 
      you're most recent guess was #{guesses.last} and your guess was #{outcome}" 
  end
end

# When the player requests the game path, 
# the server should show some information about the game 
# including how many guesses have been made, 
# what the most recent guess was, 
# and whether it was too high, too low, or correct.
