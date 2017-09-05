class CreateFrames < ActiveRecord::Migration[5.1]
  def change
    create_table :frames do |t|
      t.references :game, new: true, foreign_key: true
      t.integer :number
      t.integer :throw1
      t.integer :throw2
      t.integer :throw3
      t.integer :player_number

      t.timestamps
    end
  end
end
