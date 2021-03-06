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
    if guesses.empty?
      "Please make a guess first. Make a post request to /game."
    else
      "You've made a total of #{guesses.count} guess(s), 
      you're most recent guess was #{guesses.last} and your guess was #{guess_monitor}" 
    end
  end
end