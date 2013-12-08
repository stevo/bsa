class Admin::EventsController <  Admin::AdminController
  layout 'admin'
  inherit_resources
  defaults resource_class: Event, collection_name: 'events', instance_name: 'event'

  expose(:decorated_event){ resource.decorate }
  expose(:decorated_events){ collection.decorate.order('starts_at ASC')  }

  def create
    create! { admin_events_path }
  end

  def update
    update! { admin_events_path }
  end

  private

  def permitted_params
    params.permit(event: [:name, :description, :transition, :starts_at])
  end
end
