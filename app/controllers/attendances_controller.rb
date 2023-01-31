class AttendancesController < ApplicationController
  def create
    if attendance_exists?
      redirect_to root_path, alert: 'You have already registered for this event.'
    else
      create_attendance
      redirect_to root_path, notice: 'You have successfully registered for the event.'
    end
  end

  def destroy
    RestClient.delete("#{supabase_url}/rest/v1/attendances?attended_event_id=eq.#{params[:attended_event_id]}&attendee_id=eq.#{current_user}", common_headers)
    redirect_to root_path, notice: 'Sucessfully unregistered.'
  end

  private

  def attendance_exists?
    response = RestClient.get("#{supabase_url}/rest/v1/attendances?attended_event_id=eq.#{params[:attended_event_id]}&attendee_id=eq.#{current_user}&select=*", common_headers.merge({ Range: '0-9' }))
    !JSON.parse(response.body).empty?
  end

  def create_attendance
    RestClient.post("#{supabase_url}/rest/v1/attendances", { attendee_id: current_user, attended_event_id: params[:attended_event_id] }.to_json, common_headers.merge({ Content_Type: 'application/json', Prefer: 'return=minimal' }))
  end
end
