class FramesController < ApplicationController
  def index
    @game = Game.find(params[:game_id])
    @frames = @game.frames.order("player_number, number")
  end
end
