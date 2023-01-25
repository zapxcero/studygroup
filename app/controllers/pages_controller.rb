class PagesController < ApplicationController
  def home; end

  def login; end

  def login_create
    headers = {
      'apikey': ENV['supabase_api_key'],
      'Content-Type': 'application/json'
    }

    payload = {
      email: params[:email],
      password: params[:password]
    }
    response = RestClient.post('https://lwznbznauavlibpsepta.supabase.co/auth/v1/token?grant_type=password', payload.to_json, headers)
    if response.success?
      data = JSON.parse(response.body)
      session[:user_id] = data['id']
      session[:data] = data
    end

    redirect_to root_path, notice: 'Logged in successfully!'
  end

  def signup; end

  def signup_create
    headers = {
      'apikey': ENV['supabase_api_key'],
      'Content-Type': 'application/json'
    }

    payload = {
      email: params[:email],
      password: params[:password]
    }
    response = RestClient.post('https://lwznbznauavlibpsepta.supabase.co/auth/v1/signup', payload.to_json, headers)

    data = JSON.parse(response.body)
    session[:user_id] = data['id']
    session[:data] = data

    redirect_to root_path, notice: 'Signed up successfully!' if response.success?
  end

  def logout
    session.clear
    redirect_to root_path, noticed: 'Logged out successfully!'
  end
end
