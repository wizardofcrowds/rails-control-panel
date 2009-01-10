# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def human_time(time)
    "#{time_ago_in_words(time)} ago"
  end
  
  def app_url(app)
    "#{app.name}.#{TUTOR_NAME}.#{DNS_DOMAIN}"
  end

end
