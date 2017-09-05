class GamesController < ApplicationController
  before_action :find_game, only: [:show, :throw, :destroy]

  def create
    @game = Game.new(game_params[:game])
    if @game.save
      redirect_to @game, notice: 'Game added, roll'
    else
      render :new
    end
  end

  def show
  end

  def index
    @games = Game.order(:created_at).last(15)
  end

  def throw
    @game.throw!(params[:pins_down])
    if @game.game_over?
      redirect_to games_path, notice: 'Game over'
    else
      redirect_to @game, notice: 'Ball has been thrown'
    end
  end

  def new
    @game = Game.new
  end

  def destroy
    @game.destroy
    redirect_to games_path, notice: "Game has been destroyed"
  end

  private

  def find_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.permit(game: [:players_count, {:players_names => []}])
  end
end
