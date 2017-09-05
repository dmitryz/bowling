class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.integer :players_count
      t.text :players_names

      t.timestamps
    end
  end
end
