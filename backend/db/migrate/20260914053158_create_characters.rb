class CreateCharacters < ActiveRecord::Migration[8.1]
  def change
    create_table :characters do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :name, null: false, default: "冒険者"
      t.integer :level, null: false, default: 1
      t.integer :gold, null: false, default: 100
      t.integer :experience_points, null: false, default: 0
      t.integer :base_hp, null: false, default: 20
      t.integer :base_attack, null: false, default: 5
      t.integer :base_defense, null: false, default: 5
      t.integer :base_speed, null: false, default: 5
      t.integer :base_luck, null: false, default: 5

      t.timestamps
    end
  end
end
