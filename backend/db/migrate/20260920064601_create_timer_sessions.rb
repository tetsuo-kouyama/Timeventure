class CreateTimerSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :timer_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :focus_minutes, null: false
      t.integer :break_minutes, null: false
      t.integer :phase, null: false
      t.integer :status, null: false
      t.datetime :phase_started_at, null: false
      t.datetime :phase_ends_at, null: false

      t.timestamps
    end
  end
end
