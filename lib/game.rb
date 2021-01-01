# frozen_string_literal: true

require_relative './display.rb'
require_relative './games_persistence.rb'

class Game
  include Display
  include GamesPersistence

  def initialize
    @score = 0
    @starting_guess_count = 9
    @remaining_guesses = @starting_guess_count
    @already_guessed_letters = []
    @word =  chose_word
  end

  def chose_word
    words_array = File.readlines("5desk.txt").map(&:strip)
    @word = words_array.select{|word| word.length.between?(5,12)}.sample.downcase
  end

  def play_round
      game_screen
      start_turn
      end_game_when_lost
      next_round_when_won
  end

  def start_turn
    input = user_input(round_instructions, /^[a-z12]{1}$/ )
    if input == "1"
      save_game 
      game_screen
      puts name_after_save
      input = gets.chomp   
      return
    end
    if input == "2"
      game_screen
      load_game
      return
    end
    @word.include?(input) ? @score += 1 : @remaining_guesses -= 1
    @already_guessed_letters << input
  end

  def won_round?
    @word.each_char { |letter| 
      return false unless @already_guessed_letters.include?(letter)}
    true
  end

  def next_round_when_won
    next_round if won_round?
  end

  def next_round
    game_screen
    puts round_complete
    input = gets.chomp    #gives a pause for player to see their completed word.
    setup_next_round
  end

  def setup_next_round
    @remaining_guesses += @starting_guess_count
    @already_guessed_letters = []
    @word =  chose_word
  end

  def end_game_when_lost
    if @remaining_guesses < 1
      game_screen
      propose_new_game 
    end
  end

  def propose_new_game
    user_input(propose_new_game, /[12]/) == "1" ? setup_new_game : exit
  end

  def setup_new_game
    @score = 0
    @remaining_guesses = @starting_guess_count
    @already_guessed_letters = []
    @word =  chose_word
  end

  def user_input(prompt, regex)
    print prompt
    loop do
      input = gets.chomp.downcase
      
      if input.match(regex) && !@already_guessed_letters.include?(input)
        break input
      else
        puts(invalid_input)
      end

    end
  end  
end
