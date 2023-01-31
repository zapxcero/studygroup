class PagesController < ApplicationController
  def login; end

  def signup; end

  def login_create
    payload = {
      email: params[:email],
      password: params[:password]
    }
    data = api_call('/auth/v1/token?grant_type=password', payload)
    session[:user_id] = data['user']['id']
    session[:data] = data
    redirect_to root_path, notice: 'Logged in successfully!'
  end

  def signup_create
    payload = {
      email: params[:email],
      password: params[:password],
      data: {
        full_name: params[:full_name]
      }
    }
    data = api_call('/auth/v1/signup', payload)
    session[:user_id] = data['id']
    session[:data] = data
    redirect_to root_path, notice: 'Signed up successfully!'
  end

  def logout
    reset_session
    redirect_to root_path, notice: 'Logged out successfully!'
  end

  private

  def api_call(url, payload)
    headers = {
      'apikey': ENV['supabase_api_key'],
      'Content-Type': 'application/json'
    }

    response = RestClient.post("#{supabase_url}#{url}", payload.to_json, headers)
    data = JSON.parse(response.body)
    data
  end
end
