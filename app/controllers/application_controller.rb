class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :store_path, :require_login!

  helper_method :is_admin?, :require_admin!, :is_active?

  def is_admin?
    if @current_user && @current_user.admin
      return true
    else
      return false
    end
  end

  def require_admin!
    if not is_admin?
      redirect_to :back, alert: 'Admin rights are required to perform that activity.'
    end
  end

  def is_active?(controller)
    'active' if controller_name == controller
  end

  private

  def current_user
    begin
      user = User.find(session[:user_id]) if session[:user_id]
    rescue
      return nil
    end
    user ||= authenticate_with_http_token { |t,o| user = Profile.find_by_apikey(t).user }
    @current_user ||= user
  end

  def require_login!
    user = current_user
    if user == nil
      respond_to do |format|
        format.html { redirect_to signin_path }
        format.json { render nothing: true, status: :unauthorized }
      end
    end
  end

  def store_path
    session[:last_path] = request.env['PATH_INFO']
  end

end
