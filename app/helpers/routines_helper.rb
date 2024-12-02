# app/helpers/routines_helper.rb
module RoutinesHelper
  def render_time_with_icon(starttime, endtime)
    start_hour = starttime.hour
    end_hour = endtime.hour

    # Determine the correct icon based on the time of day
    icon = if start_hour >= 4 && start_hour < 9
              'sunset.svg' # Early morning to 9:00 AM
            elsif start_hour >= 9 && start_hour < 14
              'sun.svg'   # 9:00 AM to 2:00 PM
            elsif start_hour >= 14 && start_hour < 20
              'sunset.svg' # 2:00 PM to 8:00 PM
            else
              'moon.svg'  # 8:00 PM to 4:00 AM
            end

    # Format the time and return the HTML with the icon and the time range
    icon
  end
end
