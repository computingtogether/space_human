# frozen_string_literal: true
require 'yaml'

module GamesPersistence

  def save_game
    @filename = "#{game_title}.yaml"
    File.open("saved_games/#{@filename}", 'w'){ |file|
      file.write create_YAML_file
      name_after_save
    }
  end

  def create_YAML_file 
    YAML.dump({
      "score" => @score, 
      "starting_guess_count" => @starting_guess_count,
      "already_guessed_letters" => @already_guessed_letters,
      "word" => @word
    })
  end


  def load_game
    puts load_game_prompt
    show_file_options(file_list)
    file_number = user_input("", /[1-#{file_list.size}]/).to_i
    file_to_load = file_list[file_number-1]
    load_instance_variables(file_to_load)
  end

  def load_instance_variables(from_file)
    loaded_game = YAML.safe_load(File.read("saved_games/#{from_file}"))
    @score = loaded_game["score"]
    @starting_guess_count = loaded_game["starting_guess_count"]
    @already_guessed_letters = loaded_game["already_guessed_letters"]
    @word = loaded_game["word"]
  end

  def file_list 
    @file_names = Dir.entries("saved_games")
    @file_names.select!{|file| file.match(/(points)/)}
  end

  def show_file_options(file_list)
    file_list.each_with_index do |game, index| 
      puts saved_game(index + 1, game )
    end
  end

  def game_title
    adjective = %w[fun rad glowing happy zesty rampant fast square triangular boxy scratchy]
    noun = %w[whale chair desk squirrel iguana marsupial falcon rat minivan house]
 
    "#{adjective[rand(0..adjective.length-1)]}_#{noun[rand(0..noun.length-1)]}_#{@score}_points"
  end


end