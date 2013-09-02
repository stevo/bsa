class Admin::User::ContributionsController < Admin::AdminController
  inherit_resources
  belongs_to :user
  actions :index, :new, :create, :destroy
end
