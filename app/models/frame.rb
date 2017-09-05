class GameOverError < StandardError; end
class Frame < ApplicationRecord
  MAX_FRAME_NUMBER = 10
  MIN_FRAME_NUMBER = 1
  STRIKE_BALLS = 10
  SCORE_INIT_COUNT = 2
  SCORE_AFTER_STRIKE_COUNT = 1
  SCORE_AFTER_SPARE_COUNT = -1

  belongs_to  :game

  validates_presence_of :game, :number, :player_number
  validates :number, numericality: { greater_than_or_equal_to: MIN_FRAME_NUMBER, less_than_or_equal_to: MAX_FRAME_NUMBER }

  def throws
    [self.throw1, self.throw2, self.throw3]
  end

  def throw!(pins_down)
    raise GameOverError if game_over?
    add_throw(pins_down)
    save!
  end

  def next_player_number
    next_number = player_number + (finished? ? 1 : 0)
    return 1 if next_number > game.players_count
    next_number
  end

  def next_frame_number
    return number if final?
    number + (finished? ? 1 : 0)
  end

  def game_over?
    final? && finished?
  end

  def throw_number
    throws.reject(&:nil?).count + 1
  end

  def finished?
    if final?
      return true if (strike? || spare?) && self.throws.third
      return true if (!strike? && !spare?) && self.throws.second
      return false
    else
      return strike? || self.throws.second
    end
  end

  def final?
    self.number == MAX_FRAME_NUMBER
  end


  def score(deep_count=SCORE_INIT_COUNT)
    return throws_score(1) if deep_count == SCORE_AFTER_SPARE_COUNT || deep_count < SCORE_AFTER_STRIKE_COUNT

    if strike?
      return throws_score(1,2) if final? && deep_count < SCORE_INIT_COUNT
      return throws_score(1,2,3) if final?
      return throws_score(1) + next_frame_by_player_score(deep_count-1)
    end

    return throws_score(1,2) if deep_count < SCORE_INIT_COUNT
    return throws_score(1,2,3) if final?
    return throws_score(1,2) + next_frame_by_player_score(SCORE_AFTER_SPARE_COUNT) if spare?

    throws_score(1,2)
  end

  private

  def throws_score(*throws)
    throws.collect { |i| self.throws[i-1].to_i }.sum
  end

  def next_frame_by_player_score(deep_count)
    _next_frame = next_frame_by_player
    _next_frame ? _next_frame.score(deep_count) : 0
  end

  def next_frame_by_player
    game.frames.where(player_number: self.player_number, number: self.number + 1).first
  end

  def strike?
    self.throws.first == STRIKE_BALLS
  end

  def spare?
    !strike? && throws_score(1,2) == STRIKE_BALLS
  end

  def add_throw(val)
    if self.throw1.nil?
      self.throw1 = val 
    elsif self.throw2.nil?
      self.throw2 = val
    elsif self.throw3.nil?
      self.throw3 = val
    end
  end


end
