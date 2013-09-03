class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :voting_id
      t.integer :voter_id
      t.string :state

      t.timestamps
    end
  end
end
