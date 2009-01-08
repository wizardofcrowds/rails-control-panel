class App < ActiveRecord::Base
  include Authentication
  require 'nettica/client'
  
  belongs_to :user
  validates_presence_of :name, :user_id
  validates_uniqueness_of :name

  validates_format_of :name, :with => Authentication.login_regex, :message => Authentication.bad_login_message
  
  after_create :add_a_record
  
  def add_a_record
    client = Nettica::Client.new('hogehoge','hoge')
    d = client.create_domain_record(DNS_DOMAIN, "#{name}.#{TUTOR_NAME}", "A", "67.202.40.233", 1)
    client.add_record(d)
  end
  
end
