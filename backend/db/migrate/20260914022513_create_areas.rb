class CreateAreas < ActiveRecord::Migration[8.1]
  def change
    create_table :areas do |t|
      t.references :prerequisite_area, foreign_key: { to_table: :areas }
      t.string :name, null: false
      t.integer :area_type, null: false
      t.integer :battle_weight, null: false
      t.integer :treasure_weight, null: false

      t.timestamps
    end
  end
end
