include Open4

class SpecialGem < ActiveRecord::Base
  validates_presence_of :name
  validates_format_of :name, :with => /\A\w[\w\-_]+\z/ 
  validates_format_of :version, :with => /\A[0-9\.]*\z/
  
  def before_validation
    self.version = "" unless self.version
  end
  
  
  def before_create
    begin
      unless RAILS_ENV=="test"
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
      self.result_status = status
      self.result_stdout = stdout
      self.result_stderr = stderr
    rescue
      puts $!
    end
  end
  
end
