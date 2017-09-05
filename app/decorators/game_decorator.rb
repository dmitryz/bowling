class GameDecorator < Draper::Decorator
  delegate_all

  def players_score
    (1..model.players_count).collect { |num| "#{num}##{game.score(num)}" }.join(",")
  end

end
