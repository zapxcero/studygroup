class AttendancesController < ApplicationController
  def create
    headers = {
      apikey: ENV['supabase_api_key'],
      Authorization: "Bearer #{ENV['supabase_api_key']}",
      Range: '0-9'
    }
    url = "#{supabase_url}/rest/v1/attendances?attended_event_id=eq.#{params[:attended_event_id]}&attendee_id=eq.#{current_user}&select=*"
    response = RestClient.get(url, headers)
    data = JSON.parse(response.body)

    if data.empty?
      headers = {
        apikey: ENV['supabase_api_key'],
        Authorization: "Bearer #{ENV['supabase_api_key']}",
        Content_Type: 'application/json',
        Prefer: 'return=minimal'
      }
      url = "#{supabase_url}/rest/v1/attendances"
      payload = { attendee_id: current_user, attended_event_id: params[:attended_event_id] }

      RestClient.post(url, payload.to_json, headers)
      redirect_to root_path, notice: 'You have successfully registered for the event.'
    else
      redirect_to root_path, alert: 'You have already registered for this event.'
    end
  end

  def destroy
    headers = {
      apikey: ENV['supabase_api_key'],
      Authorization: "Bearer #{ENV['supabase_api_key']}"
    }
    url = "#{supabase_url}/rest/v1/attendances?attended_event_id=eq.#{params[:attended_event_id]}"

    RestClient.delete(url, headers)
    redirect_to root_path, notice: 'Sucessfully unregistered.'
  end
end
