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

  def show; end

  def new; end

  def create
    headers = {
      apikey: ENV['supabase_api_key'],
      Authorization: "Bearer #{ENV['supabase_api_key']}",
      Content_Type: 'application/json',
      Prefer: 'return=minimal'
    }

    data = { name: params[:event][:name], location: params[:event][:location], date: params[:event][:date], creator_id: current_user }

    response = RestClient.post 'https://lwznbznauavlibpsepta.supabase.co/rest/v1/events', data.to_json, headers

    redirect_to root_path, notice: 'Study Group Created successfully!' if response.code >= 200 && response.code < 300
  end

  def edit; end

  def update; end

  def destroy; end
end
