class AddActiveToVotings < ActiveRecord::Migration
  def change
    add_column :votings, :active, :boolean, default: true
  end
end
