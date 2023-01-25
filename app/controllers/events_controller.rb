class EventsController < ApplicationController
  def index
    headers = {
      'apikey': ENV['supabase_api_key'],
      'Authorization': "Bearer #{ENV['supabase_api_key']}"
    }

    response = RestClient.get("#{SUPABASE_URL}/rest/v1/events?select=id,name,location,date,creator_id", headers)
    gz = Zlib::GzipReader.new(StringIO.new(response.body))
    @events = JSON.parse(gz.read)
  end
end
