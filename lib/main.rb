# frozen_string_literal: true

require_relative './game.rb'
require_relative './display.rb'
require_relative './games_persistence.rb'

include Display
include GamesPersistence

def run_game
  game = Game.new
  loop do
    game.play_round
  end
end

run_game