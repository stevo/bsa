class ConfirmationsController < Devise::ConfirmationsController
  layout 'master', only: :new
end
