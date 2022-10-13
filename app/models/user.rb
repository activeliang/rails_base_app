class User < ApplicationRecord
  has_secure_password
  validates :name, presence: { message: '用户名不能为空' },
                 uniqueness: { message: '此用户名已存在' },
                 format: { without: /\s/, message: '用户名不能有空格' }

  validates :password, length: { in: 6..20, message: '密码长度需要在6至20位以内' }, unless: proc { |a| a.password.blank? }
  validates :password, presence: { message: '密码不能为空' }, confirmation: { message: '两次密码不一致' }, on: :create

  after_update :logout_access_token

  def user_info
    data = slice(:name, :id, :role)
  end

  def admin?
    role == 'admin'
  end

  private
    def logout_access_token
      session = JWTSessions::Session.new namespace: "user_id_#{id}"
      session.flush_namespaced_access_tokens
      session.flush_namespaced if self.is_freeze
    end
end
