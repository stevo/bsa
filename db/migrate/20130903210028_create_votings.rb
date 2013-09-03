class CreateVotings < ActiveRecord::Migration
  def change
    create_table :votings do |t|
      t.integer :membership_id
      t.boolean :closed
      t.date :finishes_at

      t.timestamps
    end
  end
end
