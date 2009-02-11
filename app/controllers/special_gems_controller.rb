class SpecialGemsController < ApplicationController
  
  def new
    @special_gem = SpecialGem.new
  end
  
  def create
    system "rake special_gem NAME=#{params[:special_gem][:name]} VERSION=#{params[:special_gem][:version]} &"
    flash[:notice]="You have sent a gem installation request."
    redirect_to user_path(current_user)
  end
  
  def show
    @special_gem = SpecialGem.find(params[:id])
  end
  
  def index
    @special_gems = SpecialGem.all
  end
  
end
