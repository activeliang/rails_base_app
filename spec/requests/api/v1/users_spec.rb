require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  before do
    @u = User.create name: 'liang', password: '123456', password_confirmation: '123456', role: 'admin'
    @u2 = User.create name: 'liang2', password: '123456', password_confirmation: '123456', role: 'aaaaa'
    post '/api/v1/login', params: { name: 'liang', password: '123456' }
    data = JSON.parse response.body
    @headers = { 'Authorization': "Bearer #{data['data']['access']}" }
    post '/api/v1/login', params: { name: 'liang2', password: '123456' }
    data = JSON.parse response.body
    @headers2 = { 'Authorization': "Bearer #{data['data']['access']}" }
  end

  describe "只有管理员才能看到所有用户" do
    it "有权限正常拿" do
      get '/api/v1/users', headers: @headers
      data = JSON.parse response.body
      expect(data['code']).to eq(0)
      expect(data['data'].count).to eq(2)
    end

    it "无权限的" do
      get '/api/v1/users', headers: @headers2
      data = JSON.parse response.body
      expect(response).to have_http_status(403)
    end

    it "没登录的" do
      @u.update role: 'aaaa'
      get '/api/v1/users'
      data = JSON.parse response.body
      expect(response).to have_http_status(401)
    end
  end

  describe "正常新增" do
    it "正常新增" do
      puts "\033[42;30m#{@headers}\033[0m"
      post '/api/v1/users', params: { name: '13788888888', password: 'kkkkkk', password_confirmation: 'kkkkkk' }, headers: @headers
      expect(response).to have_http_status(201)
      expect(User.last.name).to eq('13788888888')
    end

    it "无法正常新增, 需要管理员权限" do
      post '/api/v1/users', params: { name: '13788888888', password: 'kkkkkk', password_confirmation: 'kkkkkk' }, headers: @headers2
      expect(response).to have_http_status(403)
      expect(User.count).to eq(2)
    end
  end
end
