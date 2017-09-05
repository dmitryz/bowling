require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe "Single player" do
    let(:players_names) { %w{Dmitry} }
    let(:game) { Game.create!(players_count: 1, players_names: players_names) }

    it "should throw" do
      frame = game.throw!(5)
      expect(frame.number).to eq(Frame::MIN_FRAME_NUMBER)
    end

    it "should throw many times" do
      game.throw!(5)
      game.throw!(3)
      frame = game.throw!(7)
      expect(frame.number).to eq(2)
      expect(frame.player_number).to eq(1)
    end

    it "should count frames and scores" do
      18.times { game.throw!(4) }
      frame = game.throw!(4)
      expect(frame.number).to eq(10)
      expect(frame.player_number).to eq(1)
      expect(game.frames.count).to eq(10)
      expect(game.score).to eq(4*19)
    end

    it "should count frames and scores by strikes" do
      9.times { game.throw!(10) }
      game.throw!(4)
      frame = game.throw!(4)
      expect(frame.number).to eq(10)
      expect(frame.player_number).to eq(1)
      expect(game.score).to eq(30*7 + (10+10+4) + (10+4+4) + 4 + 4)
    end

    it "should count frames and scores by strikes and spares" do
      9.times { game.throw!(10) }
      game.throw!(5)
      game.throw!(5)
      frame = game.throw!(10)
      expect(frame.number).to eq(10)
      expect(frame.player_number).to eq(1)
      expect(game.score).to eq(30*7 + (10+10+5) + (10+5+5) + (5+5+10))
    end

    it "should get maximum score" do
      12.times { game.throw!(10) }
      expect(game.score).to eq(300)
    end

    it "should not overload the game" do
      12.times { game.throw!(10) }
      expect do
        game.throw!(5)
      end.to raise_error(GameOverError)
      expect(game.score).to eq(300)
    end

    it "should calculate a spare" do
      2.times { game.throw!(5) }
      game.throw!(4)
      expect(game.score).to eq(18)
    end

    it "should calculate a strike" do
      game.throw!(10)
      game.throw!(4)
      game.throw!(5)
      expect(game.score).to eq(28)
    end

    it "should calcualte score with spare bonus in last frame" do
      18.times { game.throw!(2) }
      2.times { game.throw!(5) }
      game.throw!(4)
      expect(game.score).to eq(18*2 + 10 + 4)
    end

    it "should game over" do
      20.times { game.throw!(3) }
      expect(game.game_over?).to be_truthy
    end

    it "should calculate poor game" do
      20.times{ game.throw!(1) }
      expect(game.score).to eq(20)
    end

    it "should calculate worst game" do
      20.times{ game.throw!(0) }
      expect(game.score).to eq(0)
    end
  end

  describe "Multiple players" do
    let(:players_names) { %w{Dmitry John Mustafa} }
    let(:game) { Game.create!(players_count: 3, players_names: players_names) }

    it "should create it self" do
      frame = game.frames.create!(player_number: 1, number: 1)
      expect(frame.number).to eq(Frame::MIN_FRAME_NUMBER)
    end

    it "should throw" do
      frame = game.throw!(5)
      expect(frame.number).to eq(Frame::MIN_FRAME_NUMBER)
    end

    it "should throw many times" do
      game.throw!(5)
      game.throw!(3)
      frame = game.throw!(7)
      expect(frame.number).to eq(1)
      expect(frame.player_number).to eq(2)
    end

    it "should count frames" do
      18.times { game.throw!(4) }
      frame = game.throw!(4)
      expect(frame.number).to eq(4)
      expect(frame.player_number).to eq(1)
    end

    it "should count frames by strikes" do
      19.times { game.throw!(10) }
      frame = game.throw!(4)
      expect(frame.number).to eq(7)
      expect(frame.player_number).to eq(2)
    end
  end
end
