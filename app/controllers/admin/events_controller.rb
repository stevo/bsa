class Admin::EventsController <  Admin::AdminController
  layout 'admin'
  inherit_resources
  defaults :resource_class => Event, :collection_name => 'events', :instance_name => 'event'

  def create
    create! { admin_events_path }
  end

  def update
    update! { admin_events_path }
  end

  private

  def permitted_params
    params.permit(events: [:name,:description])
  end
end
