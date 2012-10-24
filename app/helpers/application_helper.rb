module ApplicationHelper

  def bar_collection
    Bar.all.map{|b| [b.name, b.id]}
  end

  def states_collection
    States.pluck(:name)
  end

  def users_collection
    User.where("name IS NOT NULL").map{|u| [u.name, u.id]}
    #    User.all
  end

  def days
    [["Monday", 0], ["Tuesday", 1], ["Wednesday", 2], ["Thursday", 3], ["Friday", 4], ["Saturday", 5],["Sunday", 6]]
  end
  def days_on_edit
    [["Monday", "Monday"], ["Tuesday", "Tuesday"], ["Wednesday", "Wednesday"], ["Thursday", "Thursday"], ["Friday", "Friday"], ["Saturday", "Saturday"],["Sunday", "Sunday"]]
  end
  
  def days_collection
    [["Monday", "Monday"], ["Tuesday", "Tuesday"], ["Wednesday", "Wednesday"], ["Thursday", "Thursday"], ["Friday", "Friday"], ["Saturday", "Saturday"],["Sunday", "Sunday"]]
  end

  def avaliable_cities
    City.all.map{|c| [c.name, c.name]}
  end

  def sport_teams_collection
    #    SportTeam.all.map{ |s| [s.team_name, s.team_name] }
    SportTeam.all.map{ |s| s.team_name }
  end

  def radius_collection
    GeoRadius.order("radius").all.map{ |g| [g.radius, g.radius] }
  end

  def gift_collections
    Gift.where(["bar_id is NULL OR bar_id = (?)", current_bar.id ]).order("created_at DESC").map{ |reward| [reward.descriptions, reward.descriptions] }.unshift([nil, nil])
  end

  def reward_collections
    Reward.where(["bar_id = (?) OR bar_id = (?)", nil, current_bar.id ]).all.map{ |g| [g.name , g.id] }.unshift
  end

  #  scope :n_line, gsub("\r\n","<br/>").html_safe

  def n_line(des)
    des.gsub("\r\n","<br/>").html_safe
  end

  def age(user)
    now = Time.now.utc.to_date
    now.year - student.date_of_birth.year - (student.date_of_birth.change(:year => now.year) > now ? 1 : 0)
  end

  def bar_collection
    Bar.all.map { |b| [b.name, b.id] }
  end
  
  def user_message_collection
    User.all.map { |u| [u.name, u.id] unless u.name.blank?}.compact
  end

  def hours_collection
    [[1,1.0],[2,2.0],[3,3.0],[4,4.0],[5,5.0],[6,6.0],[7,7.0],[8,8.0],[9,9.0],[10,10.0],[11,11.0],[12,12.0]]
  end

  def geo_radius_collection
    GeoRadius.all.map{ |gr| [gr.radius, gr.radius]}
  end

  def states_collection
    States.all.map{ |s| [s.name, s.name] }
  end

  def bigswig_collection
    #    BigSwigList.all.map{ |b| [b.big_swig, b.big_swig] }
    BigSwigList.where(["bar_id IS NULL OR bar_id = ?", current_bar.id]).map{ |b| [b.big_swig, b.big_swig] }
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def loyalty_expirate_date(reward_date)
    (reward_date + (@loyalty_reward_policy rescue 0).days).strftime("%v")
  end
  
  def popularity_expirate_hours(reward_date)
    (reward_date + (@loyalty_reward_policy rescue 0).days).strftime("%v")
  end

  def counting_day(day)
    (day - Date.today).to_i
  end

  def counting_time(hours)
    a = (hours - Time.now).to_i
    case a
    when 0 then return 'just now'
    when 1 then return 'a second again'
    when 2..59 then return a.to_s+' seconds again'
    when 60..119 then return 'a minute again' #120 = 2 minutes
    when 120..3540 then return (a/60).to_i.to_s+' minutes again'
    when 3541..7100 then return 'an hour again' # 3600 = 1 hour
    when 7101..82800 then return ((a+99)/3600).to_i.to_s+' hours again'
    when 82801..172000 then return 'a day again' # 86400 = 1 day
    when 172001..518400 then return ((a+800)/(60*60*24)).to_i.to_s+' days again'
    when 518400..1036800 then return '1 week again'
    end
    return ((a+180000)/(60*60*24*7)).to_i.to_s+' weeks again'
  end

end
