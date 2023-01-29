require 'rest-client'
require 'pry'

class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :supabase_url

  def current_user
    @current_user ||= session[:user_id]
  end

  def supabase_url
    'https://lwznbznauavlibpsepta.supabase.co'.freeze
  end
end
