class RenameColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :games, :player_1_turns, :player_1_hits
    rename_column :games, :player_2_turns, :player_2_hits
  end
end
