class AddNextEventIndexToAdventures < ActiveRecord::Migration[8.1]
  def change
    add_column :adventures, :next_event_index, :integer, null: false, default: 1
  end
end
