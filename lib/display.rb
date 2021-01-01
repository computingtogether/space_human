# frozen_string_literal: true
#This module is highly coupled to the Game class, I opted to use Game's instance variables
#over writing methods that take generic params. 

module Display

  def colorize(color, element)
    return "\e[#{color}m#{element}\e[0m"
  end

  def title
    <<-HEREDOC
     _   _   _   _  _                    _
    (_  |_) |_| |  |_    |_| | | |\\  /| |_| |\\ |
     _\) |   | | |_ |_    | | |_| | \\/ | | | | \\|
    HEREDOC
  end

  def astronaut
    <<-HEREDOC
                            __
                     /\\   /   \\   
                     \\/\\--\\___/_
                      \\___       \\  
                        |  NASA | |  
                        /       /\\/  
                       /      / \\/    
                       /  .|  |  
                       \\  \\|  |
                      /__/ |__|
    HEREDOC
  end

  def planet
    <<-HEREDOC
                      ________
               _______        _______
          _____                      _____
      ____                                ____
   ___                                         ___
 __                                               __
_                                                   _
    HEREDOC
  end

  def propose_new_game
    <<~HEREDOC

      Game over! The word was #{colorize(31, "\"" + @word + "\"")}. 

      Would like to play again? (1) yes  (2) no 

    HEREDOC
  end

  def round_complete
    <<~HEREDOC

      Nice work!!! Press (ENTER) for the next round. 

    HEREDOC
  end

  def invalid_input
    <<~HEREDOC

    Oops! That was not a valid input. Please try again.
    HEREDOC
  end

  def round_instructions
    <<~HEREDOC

    Type an available letter or (1) to save (2) to load.

    HEREDOC
  end

  def already_guessed
    "Oops! You have already guessed that letter. Try again. "
  end

  def remaining_guesses_and_score
    result_string = ""
    result_string += colorize(31, @remaining_guesses.to_s + " guesses left.")
    result_string += colorize(32, " You have " + @score.to_s + " points.")
    result_string.center 70
  end

  def jump_height
    @remaining_guesses > @starting_guess_count ? line_breaks = @starting_guess_count :
                                       line_breaks = @remaining_guesses 
    result_string = ""
    line_breaks.times { result_string += "                       .    .\n" }
    result_string
  end

  def head_room
    result_string = ""
    (@starting_guess_count + 1 - @remaining_guesses).times { result_string += "\n" }
    result_string
  end

  def alphabet
    alphabet = *'a'..'z'
    alphabet.map! { |letter| @already_guessed_letters.include?(letter) ? 
                             letter = " " :
                             letter = colorize(36, letter)}
    alphabet = alphabet.join(" ")
  end

  def word_progress
    result_string = ""
    @word.each_char { |letter| @already_guessed_letters.include?(letter) ? 
                               result_string += letter + " " : 
                               result_string += "_ " }
    result_string.center 53
  end

  def game_screen
    clear_screen
    puts title
    puts head_room
    puts astronaut
    puts jump_height
    puts planet + "\n"
    puts word_progress + "\n\n"
    puts remaining_guesses_and_score + "\n\n"
    puts " " + alphabet
  end

  def clear_screen
    print "\e[2H\e[2J" #"\e[2J\e[3;0H"
  end

  def name_after_save
    <<~HEREDOC

    Game saves as #{colorize(31, "\"" + @filename +"\"")}.
    Press (ENTER) to continue.
    HEREDOC
  end

  def saved_game(number, name)
    "(#{number}) #{name}"
  end

  def load_game_prompt
    <<~HEREDOC

    Enter the number of the game to load.
    
    HEREDOC
  end

end