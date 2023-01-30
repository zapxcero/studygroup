module ApplicationHelper
  def attendees_for_event(event_id)
    res = RestClient.get("#{supabase_url}/rest/v1/attendances?attended_event_id=eq.#{event_id}&select=attendee_id", common_headers)
    gz = Zlib::GzipReader.new(StringIO.new(res.body))
    JSON.parse(gz.read)
  end

  def attendee?(event)
    attendees = attendees_for_event(event['id'])
    attendees.map { |hash| hash['attendee_id'] }.include?(current_user)
  end

  def event_creator?(event)
    event['creator_id'] == current_user
  end
end
