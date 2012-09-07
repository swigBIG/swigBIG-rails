class Bars::RegistrationsController < Devise::RegistrationsController
  layout "bars"
  
  def after_update_path_for(resource)
    bars_completion_url
  end

  def after_sign_up_path_for(resource)
    #    if resource.created_at.strftime("%v-%R").eql?(resource.updated_at.strftime("%v-%R"))
    if current_bar.address.blank?
      AdminUser.first.send_message(current_bar, {topic: "Welcome to SwigBIG", body: "#{current_bar.name} is not yet listed! <a href='/bars/completion'>Please complete your profile</a>", category: 22})
      bars_dashboard_url
    else
      bars_dashboard_url
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    #      @bar = User.find(current_bar.id)

    if current_bar.update_attributes(params[:bar])
      # Sign in the user by passing validation in case his password changed
      sign_in current_bar, :bypass => true
      redirect_to bars_dashboard_url, notice: "Update Success!"
    else
      render action: :edit, notice: "field with * mark must filled!"
    end
  end

  def edit
    @bar_hours = current_bar.bar_hours.group_by {|hour| "#{hour.open_time} - #{hour.close_time}" }
    @counter = BarHour::DAY_LIST[@bar_hours.to_a.last.last.last.day] rescue 0
    #    @bar_hours = current_bar.bar_hours.group("open_time, close_time")
    render :edit
  end

  
end