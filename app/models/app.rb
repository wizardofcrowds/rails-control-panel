class App < ActiveRecord::Base
  include Authentication
  
  belongs_to :user
  validates_presence_of :name, :user_id
  validates_uniqueness_of :name

  validates_format_of :name, :with => Authentication.login_regex, :message => Authentication.bad_login_message
  
  def after_create
    unless RAILS_ENV == "test"    
      add_a_record
      create_rails_environment
    end
  end
  
  def add_a_record
    #TODO replace this with get
    uri = "http://#{DNS_DOMAIN}/arecords/add/#{ORDER_SECRET}?subdomain=#{SUB_DOMAIN}&subsubdomain=#{name}"
    Net::HTTP.get(URI.parse(uri))
    # client = Nettica::Client.new(NETTICA_USER,NETTICA_PASSWORD)
    # public_ipv4 = `curl  http://169.254.169.254/latest/meta-data/public-ipv4`
    # d = client.create_domain_record(DNS_DOMAIN, "#{name}.#{SUB_DOMAIN}", "A", public_ipv4, 1)
    # client.add_record(d)
  end
  
  def url
    "#{name}.#{SUB_DOMAIN}.#{DNS_DOMAIN}"
  end
  
  def create_rails_environment
    `rails #{HOME_DIR}/#{self.user.login}/#{name} -s`
    `chown #{self.user.login}:#{self.user.login} #{HOME_DIR}/#{self.user.login}/#{name} -R`
    `echo "<VirtualHost \*:80>" > /etc/apache2/sites-enabled/#{name}`
    `echo "  ServerName #{url}" >> /etc/apache2/sites-enabled/#{name}`
    `echo "  DocumentRoot #{HOME_DIR}/#{self.user.login}/#{name}/current/public" >> /etc/apache2/sites-enabled/#{name}`
    `echo "</VirtualHost>" >> /etc/apache2/sites-enabled/#{name}`
    `/etc/init.d/apache2 reload`
  end
  
end
