class PasswordsController < Devise::PasswordsController
  layout 'master'

  def new
    self.resource = resource_class.new
  end
end