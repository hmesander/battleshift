class AddTitleToUserGames < ActiveRecord::Migration[5.1]
  def change
    add_column :user_games, :title, :string
  end
end
