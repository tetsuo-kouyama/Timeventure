class CreateAdventures < ActiveRecord::Migration[8.1]
  def change
    create_table :adventures do |t|
      t.references :character, null: false, foreign_key: true
      t.references :start_area, null: false, foreign_key: { to_table: :areas }
      t.integer :planned_focus_minutes, null: false
      t.integer :status, null: false
      t.bigint :random_seed, null: false
      t.datetime :started_at, null: false
      t.datetime :ended_at

      t.timestamps
    end
  end
end
