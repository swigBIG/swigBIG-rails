class Users::BarsController < ApplicationController
  layout "bar_profile"
  
  def index

    @bars = Bar.all
    @swigs = Swig
   
    
  end

  def show
#    @bar = Bar.find(params[:bar_id])
#    @swigs = Swig.where(status: "active")
#    @swigers = @bar.swigers
#    @users = User.all
#    @popularity = Popularity.new
#    #    @users.count.times do
#    guesses = @popularity.guesses.new
#    #    end
    @bar = Bar.find(params[:bar_id])
    @bar_name = @bar.name
    @swigs = Swig.where(status: "active")
    @swigers = @bar.swigers.all
    @popularity = Popularity.where(bar_id: @bar)
    @loyalty = Loyalty.where(bar_id: @bar)
  end

  def create_popularity
    debugger
    #    @bar = Bar.find(:bar_id)
#    @popularity = Popularity.new(bar_id: @bar.id)
#params[:job].merge(dates: revert_date_to_db_format(params[:job][:dates])
    @popularity = Popularity.new(params[:popularity].merge(guesses: revert_date_to_db_format(params[:popularity][:user_id])))
     if @popularity.save
       redirect_to :back
     end
  end
end
