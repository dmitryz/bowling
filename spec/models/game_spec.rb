require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:players_names) { %w{Dmitry John Mustafa} }

  it "should create it self" do
    game = Game.create!(players_count: 3, players_names: players_names)
    expect(game.players_names).to eq(players_names)
  end

  it "should fail on create" do
    expect do
      Game.create!(players_count: 10, players_names: players_names)
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Players count must be less than or equal to 8")
  end
end
