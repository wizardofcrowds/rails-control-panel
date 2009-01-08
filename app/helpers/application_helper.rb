# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def human_time(time)
    "#{time_ago_in_words(time)} ago"
  end

end
