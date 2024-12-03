module TagHelper

  def calculate_tag(user_appliance)
    return "" if user_appliance.routines.empty?

    routines_match = user_appliance.routines.any? do |routine|
      routine.recommendations.any? do |recommendation|
        routine.starttime.wday == recommendation.starttime.wday && routine.starttime.strftime("%H:%M") == recommendation.starttime.strftime("%H:%M")
      end
    end
    routines_match ? "tag-auto" : "tag-new"
  end
end
