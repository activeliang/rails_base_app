class Api::V1::SessionController < ApplicationController
  before_action :authorize_refresh_request!, only: [:refresh, :destroy]

  def create
    user = User.find_by(name: params[:name]&.gsub(/\s*/, ''))
    if !user.present?
      render json: { name: ["用户名不存在"] }, status: 404
    elsif user.is_freeze
      render json: { name: ["帐户已冻结，请联系管理员"] }, status: 403
    elsif user.authenticate(params[:password])
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_payload: payload, refresh_by_access_allowed: true, namespace: "user_id_#{user.id}")
      render json: { code: 0, data: session.login.merge(user_info: user.user_info) }
      # render json: { code: 0 }
    else
      # binding.pry
      render json: { password: ["密码不正确"] }, status: :unprocessable_entity
    end
  end

  def refresh
    refresh_key_expired_at = Time.at claimless_payload['exp']
    payload = { user_id: current_user.id }
    session = JWTSessions::Session.new(payload: payload, refresh_payload: payload, refresh_by_access_allowed: true, namespace: "user_id_#{current_user.id}")
    # 检查过期时间是否超过两个月，如果小于两个月则重新登录，拿新的refresh key
    
    if refresh_key_expired_at - Time.now < 2.months
      render json: { code: 0, data: session.login.merge(user_info: current_user.user_info) }
    else
      render json: { code: 0, data: session.refresh(found_token).merge(user_info: current_user.user_info) }
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload,
                                   refresh_payload: payload,
                                   refresh_by_access_allowed: true,
                                   namespace: "user_id_#{current_user.id}")
    session.flush_by_token(found_token)
    render json: { code: 0 }
  end
end
