ActiveAdmin.register RequestUser do
  filter  :email
  filter  :full_name

  index do
    column  :email
    column  :enter_key

    column("Invite") do |user|
      user.enter_key.blank? ? link_to("Invite", invite_admin_request_user_path(user)) : "Invited"
    end

    default_actions
  end

  show do |b|
    attributes_table do

      row :email do
        b.email
      end

      row :enter_key do
        b.enter_key
      end

    end
  end

  form do |f|
    f.inputs "Register" do
      f.input :email
      f.input :enter_key

      f.buttons
    end
  end

  member_action :invite, :method => :get do
    user = RequestUser.find(params[:id])
    
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    serial = (0...6).collect { chars[Kernel.rand(chars.length)] }.join
    is_existed = true
    while is_existed.eql?(true)
      if RequestUser.where(enter_key: serial).first.nil?
        is_existed = false
      else
        chars = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
        serial = (0...20).collect { chars[Kernel.rand(chars.length)] }.join
      end
    end

    user.update_attributes(enter_key: serial )
    Invite.request_user_invite_to_swigbig(user).deliver
    redirect_to admin_request_users_url, :notice => "Invite!"
  end

end
