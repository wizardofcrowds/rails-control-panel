class AppsController < ApplicationController
  
  def create
    if find_user      
      @app = @user.apps.create(params[:app])
      if @app && @app.errors.empty?
        flash[:notice] = "Your new app #{@app.name} succesfully registered"
        redirect_to user_app_path(@user, @app)
      else
        flash[:notice] = "Failed to register your app #{@app.name}"
        redirect_to new_user_app_path(@user)
      end
    else
      flash[:notice] = "Appropriate user not found, failed to register the app"
      redirect_to root_path
    end
  end

  def new
    unless find_user
      flash[:notice] = "You cannot create an app which is not yours. Need to login as that user"
      access_denied
    end
  end  
  
  def edit
    unless find_user
      flash[:notice] = "You cannot edit an app which is not yours. Need to login as that user"
      access_denied
    else
      @app = @user.apps.find(params[:id]) rescue nil
      unless @app
        flash[:notice] = "Requested app not found"
        redirect_to user_apps_path(@user)      
      end
    end    
  end
  
  def update
    unless find_user
      flash[:notice] = "You cannot update an app which is not yours. Need to login as that user"
      access_denied
      return
    end
    @app = @user.apps.find(params[:id]) rescue nil
    unless @app
      flash[:notice] = "Requested app not found"
      redirect_to user_apps_path(@user) 
    else
      if @app.update_attributes(params[:app])
        redirect_to user_app_path(@user, @app)
      else
        flash[:notice] = "Failed to update the app"
        redirect_to edit_user_app_path(@user, @app)
      end      
    end
  end
  
private
  def find_user
    user = User.find(params[:user_id]) rescue nil    
    if current_user.admin? || current_user.id == user.id
      @user = user
    else
      @user = nil
    end
    @user
  end  
  
end
