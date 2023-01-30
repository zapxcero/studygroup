require 'rest-client'
require 'pry'

class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :supabase_url
  helper_method :common_headers
  helper_method :profiles

  def current_user
    @current_user ||= session[:user_id]
  end

  def supabase_url
    'https://lwznbznauavlibpsepta.supabase.co'.freeze
  end

  def common_headers
    { apikey: ENV['supabase_api_key'], Authorization: "Bearer #{ENV['supabase_api_key']}" }
  end

  def profiles
    @profiles ||= Rails.cache.fetch('profiles', expires_in: 5.minutes) do
      response = RestClient.get("#{supabase_url}/rest/v1/profiles?select=id,full_name", common_headers)
      gz = Zlib::GzipReader.new(StringIO.new(response.body))
      JSON.parse(gz.read)
    end
  end
end
