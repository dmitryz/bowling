class Game < ApplicationRecord
  MIN_PLAYERS = 1
  MAX_PLAYERS = 8

  has_many :frames, dependent: :destroy

  serialize :players_names

  validates_presence_of :players_count
  validates :players_count, numericality: { greater_than_or_equal_to: MIN_PLAYERS, less_than_or_equal_to: MAX_PLAYERS }

  def throw!(pins_down)
    frame = last_frame(current_player_number)
    frame = frames.create!(player_number: current_player_number, number: current_frame_number) if frame.nil? || (frame.finished? && !frame.final?)
    frame.throw!(pins_down)
    frame
  end

  def score(player_number = 1)
    frames.where(player_number: player_number).map(&:score).sum
  end

  def game_over?(player_number = nil)
    if player_number
      last_frame(player_number).try(:game_over?)
    else
      (1..self.players_count).all? { |player_number| game_over?(player_number) }
    end
  end


  def current_frame_number
    return 1 unless last_frame(current_player_number)
    last_frame(current_player_number).next_frame_number
  end

  def current_player_number
    return 1 unless last_frame
    last_frame.next_player_number
  end

  def current_player_name
    self.players_names[current_player_number-1] if self.players_names
  end

  def current_frame_throw
    return 1 if last_frame.nil? || last_frame.finished?
    last_frame.throw_number
  end

  private
  def last_frame(player_number = nil)
    where_opts = player_number ? { player_number: player_number } : {}
    frames.where(where_opts).last
  end

end
