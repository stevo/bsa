class CreateContribution < Interactor
  perform do
    Contribution.transaction do
      contribution = parent.contributions.build(permitted_params[:contribution])
      contribution.membership_id = parent.membership.try(:id)
      contribution.save

      ContributionExpirySetter.new(contribution).save
    end
  end
end
