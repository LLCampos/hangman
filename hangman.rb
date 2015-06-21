class Hangman
  attr_accessor :word_guess, :already_chosen, :tries_left
  attr_reader :word

  def initialize
    @word = random_word
    @tries_left = 6
    @already_chosen = []
    @word_guess = ['_'] * @word.length
  end

  def word_guess
    @word_guess.join(' ')
  end

  # returns indexes where the letters are equal
  def equal_indexs(letter)
    idxs_same = []
    word.split('').each_with_index do |wletter, index|
      idxs_same << index if letter == wletter
    end
    idxs_same
  end

  def already_played?(letter)
    if already_chosen.include?(letter)
      puts "You've already choosen the letter #{letter}! Try another one!"
      letter_choice
    else
      letter
    end
  end

  # aks the user for the letter we wants to play
  def letter_choice
    puts 'Which letter do you want to try?'
    letter = gets.chomp.downcase
    if !('a'..'z').include?(letter)
      puts 'You have to choose a letter!'
      letter_choice
    else
      already_played?(letter)
    end
  end

  def wrong(letter)
    @tries_left -= 1
    puts "'#{letter}' is not in the word!"
    lost if @tries_left == 0
    puts "Try again!\n\n"
    turns
  end

  def right(letter)
    equal_indexs(letter).each do |index|
      @word_guess[index] = letter
    end
    won unless @word_guess.include?('_')
  end

  def lost
    puts "You lost the game! The word was '#{word}'"
    play_again?
  end

  def won
    puts "You won the game! The word was '#{word}'"
    play_again?
  end

  def turns
    puts "#{word_guess}          Chances left: #{tries_left}\n\nLetters already tried: #{already_chosen.empty? ? 'None' : already_chosen.join(', ')}\n\n"
    letter = letter_choice
    @already_chosen << letter
    if equal_indexs(letter).empty?
      wrong(letter)
    else
      right(letter)
    end
    turns
  end
end

# returns a random word from dictionary with a length between 5 and 12
def random_word
  words = File.open('5desk.txt', 'r').readlines.map(&:strip)

  words = words.keep_if { |word| word.length > 4 && word.length < 13 }

  words.sample.downcase
end

# starts a new game
def start_game
  game = Hangman.new
  puts "Welcome to Hangman! :D\n\n\n"
  game.turns
end

# continues a game
def continue_game

end


def play_again?
  puts 'Do you want to play again?(Y/N)'
  input = gets.chomp.downcase
  if input == 'y'
    start_game
  else
    exit
  end
end




start_game