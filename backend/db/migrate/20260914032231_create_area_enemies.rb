class CreateAreaEnemies < ActiveRecord::Migration[8.1]
  def change
    create_table :area_enemies do |t|
      t.references :area, null: false, foreign_key: true
      t.references :enemy, null: false, foreign_key: true
      t.integer :level, null: false
      t.integer :encounter_weight, null: false

      t.timestamps
    end
    add_index :area_enemies, [ :area_id, :enemy_id ], unique: true
  end
end
