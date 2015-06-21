require 'yaml'

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
    if letter == 'save'
      save(self)
      exit
    elsif !('a'..'z').include?(letter)
      puts 'You have to choose a letter!'
      letter_choice
    else
      already_played?(letter)
    end
  end

  def wrong(letter)
    @tries_left -= 1
    puts "'#{letter}' is not in the word!"
    finish('lost') if @tries_left == 0
    puts "Try again!\n\n"
    turns
  end

  def right(letter)
    equal_indexs(letter).each do |index|
      @word_guess[index] = letter
    end
    finish('won') unless @word_guess.include?('_')
  end

  def finish(string)
    puts "You #{string} the game! The word was '#{word}'"
    File.delete('hangman_saved.yaml')
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

# starts game
def start_game
  puts 'Welcome to Hangman! :D'
  puts "If you want to save your game, input 'save' anytime.\n\n\n"
  if !File.exist?('hangman_saved.yaml') || question == '1'
    game = Hangman.new
    game.turns
  else
    load
  end
end

def question
  puts 'Do you want to start a new game or load a saved one?'
  puts '1 - New Game'
  puts '2 - Load Game'
  input = gets.chomp
  if input == '1' || input == '2'
    input
  else
    puts 'You have to insert "1" or "2"!'
    question
  end
end

def save(game)
  yaml = YAML.dump(game)
  File.open('hangman_saved.yaml', 'w') { |file| file.puts(yaml) }
end

# continues a game
def load
  yaml = File.open('hangman_saved.yaml', 'r').read
  game = YAML.load(yaml)
  game.turns
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