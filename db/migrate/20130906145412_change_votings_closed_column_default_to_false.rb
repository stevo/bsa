class ChangeVotingsClosedColumnDefaultToFalse < ActiveRecord::Migration
  def up
    change_column :votings, :closed, :boolean, default: false, null: false
    Voting.where(closed: nil).update_all(closed: false)
  end

  def down
    change_column :votings, :closed, :boolean
  end
end
