class AddTimerSessionRefToAdventures < ActiveRecord::Migration[8.1]
  def change
    add_reference :adventures, :timer_session, null: false, foreign_key: true, index: { unique: true }
  end
end
