class EventsController < ApplicationController
  def index
    response = RestClient.get("#{supabase_url}/rest/v1/events?select=id,name,location,date,creator_id", common_headers)
    gz = Zlib::GzipReader.new(StringIO.new(response.body))
    @events = JSON.parse(gz.read)
  end

  def show; end

  def new; end

  def create
    headers = common_headers.merge(
      Content_Type: 'application/json',
      Prefer: 'return=minimal'
    )
    data = { name: params[:event][:name], location: params[:event][:location], date: params[:event][:date], creator_id: current_user }.to_json

    response = RestClient.post "#{supabase_url}/rest/v1/events", data, headers

    redirect_to root_path, notice: 'Study Group created successfully!' if response.code >= 200 && response.code < 300
  end

  def edit
    headers = common_headers.merge(Range: '0-9')
    url = "#{supabase_url}/rest/v1/events?id=eq.#{params['id']}&select=id,name,location,date"

    response = RestClient.get(url, headers)
    @data = JSON.parse(response.body).first
  end

  def update
    headers = common_headers.merge(Content_Type: 'application/json', Prefer: 'return=minimal')
    url = "#{supabase_url}/rest/v1/events?id=eq.#{params[:id]}"

    data = { name: params[:event][:name], location: params[:event][:location], date: params[:event][:date] }.to_json
    response = RestClient.patch(url, data, headers)
    redirect_to root_path, notice: 'Study Group edited succesfully!'
  end

  def destroy
    headers = common_headers
    url = "#{supabase_url}/rest/v1/events?id=eq.#{params[:id]}"

    RestClient.delete(url, headers)
    redirect_to root_path, notice: 'Study Group deleted succesfully!'
  end
end
