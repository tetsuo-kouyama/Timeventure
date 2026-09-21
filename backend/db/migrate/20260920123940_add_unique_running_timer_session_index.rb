class AddUniqueRunningTimerSessionIndex < ActiveRecord::Migration[8.1]
  def change
    add_index :timer_sessions,
              :user_id,
              unique: true,
              where: "status = 0",
              name: "index_running_timer_sessions_on_user_id"
  end
end
