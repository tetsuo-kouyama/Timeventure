class CreateAdventureEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :adventure_events do |t|
      t.references :adventure, null: false, foreign_key: true
      t.integer :elapsed_seconds, null: false
      t.integer :event_index, null: false
      t.integer :event_type, null: false
      t.jsonb :payload, null: false, default: {}

      t.timestamps
    end

    add_index :adventure_events, [ :adventure_id, :event_index ], unique: true
  end
end
