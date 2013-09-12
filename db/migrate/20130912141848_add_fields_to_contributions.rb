class AddFieldsToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :expires_at, :date
    add_column :contributions, :membership_id, :integer

    Contribution.where(membership_id: nil).delete_all
    Contribution.all.each do |contribution|
      ContributionExpirySetter.new(contribution).save
    end
  end
end
