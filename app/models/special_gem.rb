include Open4

class SpecialGem < ActiveRecord::Base
  validates_presence_of :name
  validates_format_of :name, :with => /\A\w[\w\-_]+\z/ 
  validates_format_of :version, :with => /\A[0-9\.]*\z/
  
  def before_validation
    self.version = "" unless self.version
  end
  
  
  def after_create
    begin
      unless RAILS_ENV=="test" || RAILS_ENV=="development"
        com = "gem update --system"
        stdout, stderr = '', ''
        status = spawn com, 'stdout' => stdout, 'stderr' => stderr

        com = "gem sources -a http://gems.github.com"
        stdout, stderr = '', ''
        status = spawn com, 'stdout' => stdout, 'stderr' => stderr
      end
          
      com = "gem install #{self.name}"
      unless version.empty?
        com = com + " -v #{self.version}"
      end
      puts com
      stdout, stderr = '', ''
      status = spawn com, 'stdout' => stdout, 'stderr' => stderr
      self.update_attributes(:result_status => status, :result_stdout => stdout, :result_stderr => stderr, :status => "Installation completed.")
    rescue
      self.update_attributes(:status => "Failed to install. Probably could not find the specified gem with the specified version")
      puts $!
    end
  end
  
end
