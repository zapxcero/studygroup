require 'rest-client'
require 'pry'

class ApplicationController < ActionController::Base
  helper_method :current_user

  SUPABASE_URL = 'https://lwznbznauavlibpsepta.supabase.co'.freeze

  def current_user
    @current_user ||= session[:user_id]
  end
end
