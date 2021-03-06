class AccountController < ApplicationController

  skip_before_filter :login_required, :except => :register_to_project
  skip_before_filter :set_current_project

  def authorized?
    current_user ? true : false
  end
    
############# index
  def index
      redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end
############ LOGIN
def login

    if @prid == 0 
      redirect_to :controller => '/account', :action => 'project_number_zero' , :notice => "PROJECT NUMBER IS ZERO<br> USE WOLF7 or WOLF64"
      return
    end
    
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])

    if logged_in?
      :set_project  
      flash[:notice] = "Logged in successfully"
      redirect_to :controller => '/samples', :action => 'menu' , :notice => "Logged in successfully"
    else
      flash[:notice] = "Incorrect login, please try again."
      redirect_to(:action => 'incorrect_login',:flash => { :notice => "Log in failed"})
    end
  end

############ SIGNUP
  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.project_id = @prid
    @user.data_entry_only = true
    @user.save!
    self.current_user = @user
#    self.current_user = nil
    redirect_back_or_default(:controller => '/account', :action => 'index')
      flash[:notice] = "Thanks for signing up!"
#    redirect_to(:controller => '/account', :action => 'login')
#    redirect_to(:controller => '/account', :action => 'logout')
#    redirect_back_or_default(:controller => '/account', :action => 'index')
    rescue ActiveRecord::RecordInvalid
      flash[:error]
      render :action => 'signup'
  end

  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/account', :action => 'login')
  end
  

end
