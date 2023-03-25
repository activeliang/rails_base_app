class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include JWTSessions::RailsAuthorization
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  before_action :authorize_access_request!, only: [:setting]
  before_action :require_admin, only: [:setting]

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

  def anymouse_header
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Cache-Control'] = 'no-cache'
  end

  def setting
    if request.method == 'PUT'
      Setting.bulk_set params[:setting].permit!
      render json: { code: 0, msg: 'ok' }
    else
      anymouse_header
      if params[:key]
        render json: { code: 0, data: Setting.config[params[:key]] }
        return 
      end
      render json: { code: 0, data: Setting.config }
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
