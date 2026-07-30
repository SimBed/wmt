class AddFullTeamToResults < ActiveRecord::Migration[8.1]
  def change
    add_column :results, :full_team, :boolean, default: true, null: false
  end
end
