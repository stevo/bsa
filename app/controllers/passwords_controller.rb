class PasswordsController < Devise::PasswordsController
  layout 'master', only: :new
end
