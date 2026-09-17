class CreateEnemies < ActiveRecord::Migration[8.1]
  def change
    create_table :enemies do |t|
      t.string :name, null: false
      t.integer :base_hp, null: false
      t.integer :base_attack, null: false
      t.integer :base_defense, null: false
      t.integer :base_speed, null: false
      t.integer :base_luck, null: false
      t.integer :drop_gold, null: false
      t.integer :drop_experience_points, null: false

      t.timestamps
    end
  end
end
