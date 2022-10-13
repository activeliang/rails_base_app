class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include JWTSessions::RailsAuthorization
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  def index
    render template: 'layouts/application' 
  end
  
  def current_user
    @current_user ||= User.find(payload["user_id"])
  end

  def require_admin
    if !current_user.admin?
      render json: { code: 1, msg: "Not authorized" }, status: 403
    end
  end

  def paginate_data res
    { current_page: res.current_page, total_pages: res.total_pages, per_page: res.per_page }
  end

  private
    def not_authorized
      render json: { error: "Not authorized" }, status: :unauthorized
    end
end
