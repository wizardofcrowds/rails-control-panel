class UsersController < ApplicationController

  before_filter :admin_login_required, :except => [:show, :update, :edit]

  # render new.rhtml
  def new
    @user = User.new
  end
  
  def index
    @users = User.all
  end
  
  def edit
    limit_self_access_only
    unless @user
      flash[:notice]="You don't have permission to access the user"
      redirect_to root_path
    end
  end
  
  def update
    limit_self_access_only
    if @user
      if @user.update_attributes(params[:user])
        flash[:notice] = "successfully updated"
      else
        flash[:notice] = "failed to update"
      end
      redirect_to(edit_user_path(params[:id]))
    else
      flash[:notice]="You don't have permission to access the user"
      redirect_to(root_path)
    end
  end
  
  def show
    limit_self_access_only
    unless @user
      flash[:notice]="You don't have permission to access the user"
      redirect_to root_path
    end    
  end
  
 
  def create      
#    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
#      self.current_user = @user # !! now logged in
      redirect_to user_path(@user)
      flash[:notice] = "User #{params[:user][:login]} created."
    else
      flash[:notice]  = "We couldn't set up that account, sorry.  Please try again, or contact the server owner."
      render :action => 'new'
    end
  end
  
private
  def admin_login_required
    if current_user.nil?
      access_denied
      flash[:notice] = "You should login to do that request."
    elsif !current_user.admin?
      access_denied
      flash[:notice] = "You should have administrator privillege for that request."
    end
  end  
  
  def limit_self_access_only
    if current_user.admin? || current_user.id == params[:id].to_i
      @user = User.find(params[:id]) rescue nil
    end
  end
end
