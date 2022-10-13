require 'rails_helper'

RSpec.describe "Api::V1::Session", type: :request do

  before do
    @u = User.create name: 'liang', password: '123456', password_confirmation: '123456'
  end

  describe "正常登录.login" do
    it "normal" do
      params = { name: 'liang', password: '123456' }
      post '/api/v1/login', params: params
      data = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(data['code']).to eq(0)
      data['data']['access'].should_not be_nil
    end

    it "密码不对无法登录" do
      params = { name: 'liang', password: '1234567' }
      post '/api/v1/login', params: params
      expect(response).to have_http_status(422)
      # byebug
      expect(JSON.parse(response.body)['password'].to_s.include?("密码")).to eq(true)
    end

    it "用户名不对时无法登录，并有用户名不对的提示" do
      params = { name: 'liangg', password: '1234567' }
      post '/api/v1/login', params: params
      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)['name'].to_s.include?("用户")).to eq(true)
    end
  end

  describe "正常刷新.refresh" do
    before do
      JWTSessions::Session.flush_all
      params = { name: 'liang', password: '123456' }
      post '/api/v1/login', params: params
      @res = JSON.parse response.body
    end

    it "正常刷新" do
      old_access = @res['data']['access']
      old_refresh = @res['data']['refresh']

      # post '/api/v1/refresh', params: {}, headers: { 'Authorization': "Bearer #{old_refresh}" }
      post '/api/v1/refresh', params: {}, headers: { 'X-Refresh-Token': "Bearer #{old_refresh}" }
      data = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(data['code']).to eq(0)
      data['data']['access'].should_not be_nil
    end

    it "当超过两个月时，刷新时会重新登录带refresh key" do
      # 手动修改redis中源数据的过期时间
      redis_key = $redis.keys("*#{JWTSessions.token_store.prefix}_user_id_#{@u.id}_refresh_*")&.last
      # binding.pry
      # $redis.hgetall redis_key
      # $redis.hset redis_key, "expiration", (Time.now + 1.months).to_i

      allow(Time).to receive(:now).and_return(Time.now + 2.months)

      old_refresh = @res['data']['refresh']
      post '/api/v1/refresh', params: {}, headers: { 'X-Refresh-Token': "Bearer #{old_refresh}" }
      data = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(data['data']['refresh']).to_not be_nil
    end
  end

  describe "正常退出.logout" do
    before do
      params = { name: 'liang', password: '123456' }
      post '/api/v1/login', params: params
      @res = JSON.parse response.body
      @refresh = @res['data']['refresh']
    end

    it "正常退出登录" do
      delete '/api/v1/logout', headers: { 'X-Refresh-Token': @refresh }
      expect(response).to have_http_status(200)
    end

    it "退出后不能正常登录" do
      delete '/api/v1/logout', headers: { 'X-Refresh-Token': @refresh }
      delete '/api/v1/logout', headers: { 'X-Refresh-Token': @refresh }
      expect(response).to have_http_status(401)
    end
  end

  describe "刷新，并请求链接，查看是否会出错" do
    before do
      params = { name: 'liang', password: '123456' }
      post '/api/v1/login', params: params
      @res = JSON.parse response.body
    end

    it "item" do
      old_access = @res['data']['access']
      old_refresh = @res['data']['refresh']
      @u.update role: 'admin'
      1.times {
        post '/api/v1/refresh', params: {}, headers: { 'X-Refresh-Token': "Bearer #{old_refresh}" }
        data = JSON.parse response.body
        expect(response).to have_http_status(200)
        expect(data['code']).to eq(0)
        data['data']['access'].should_not be_nil
        new_access = data['data']['access']
        get '/api/v1/users', params: {}, headers: { 'Authorization' => "Bearer #{new_access}" }
        expect(response).to have_http_status(200)
      }
    end

    it "test2" do
      # 测试jwt_session并发情况，暂未解决。401问题
      # 2.times {
      #   Thread.new {
      #     data = RestClient.post 'http://192.168.1.6:5000/api/v1/login', name: '13726470930', password: 'llllll'
      #     res = JSON.parse data
      #     2.times {|i|
      #       Thread.new {
      #         data2 = RestClient.post 'http://192.168.1.6:5000/api/v1/refresh', {}, { 'X-Refresh-Token': "Bearer #{res['data']['refresh']}" }
      #         res2 = JSON.parse data2
      #         data2 = RestClient.post 'http://192.168.1.6:5000/api/v1/refresh', {}, { 'X-Refresh-Token': "Bearer #{res['data']['refresh']}" }
      #         res2 = JSON.parse data2
      #         list = RestClient.get 'http://192.168.1.6:5000/api/v1/users?i=' + i.to_s, { :Authorization => "Bearer #{res2['data']['access']}" }
      #         puts "\033[42;30m---#{list.code}----\033[0m"
      #       }
      #     }
      #   }
      # }
    end
  end



  # TODO:  做一个踢下线的功能
end
