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

    response = RestClient.post "#{SUPABASE_URL}/rest/v1/events", data.to_json, headers

    redirect_to root_path, notice: 'Study Group created successfully!' if response.code >= 200 && response.code < 300
  end

  def edit
    headers = {
      apikey: ENV['supabase_api_key'],
      Authorization: "Bearer #{ENV['supabase_api_key']}",
      Range: '0-9'
    }
    url = "#{SUPABASE_URL}/rest/v1/events?id=eq.1&select=id,name,location,date"

    response = RestClient.get(url, headers)
    @data = JSON.parse(response.body).first
  end

  def update
    headers = {
      apikey: ENV['supabase_api_key'],
      Authorization: "Bearer #{ENV['supabase_api_key']}",
      Content_Type: 'application/json',
      Prefer: 'return=minimal'
    }
    url = "#{SUPABASE_URL}/rest/v1/events?id=eq.#{params[:id]}"

    payload = { name: params[:event][:name], location: params[:event][:location], date: params[:event][:date] }.to_json
    response = RestClient.patch(url, payload, headers)
    redirect_to root_path, notice: 'Study Group edited succesfully!'
  end

  def destroy
    headers = {
      apikey: ENV['supabase_api_key'],
      Authorization: "Bearer #{ENV['supabase_api_key']}"
    }
    url = "#{SUPABASE_URL}/rest/v1/events?id=eq.#{params[:id]}"

    RestClient.delete(url, headers)
    redirect_to root_path, notice: 'Study Group deleted succesfully!'
  end
end
