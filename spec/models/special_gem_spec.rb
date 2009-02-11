require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SpecialGem do
  before(:each) do
    @valid_attributes = {
      :name => "sprinkle",
      :version => "2.2.2" #,
#      :result_status => "value for result_status",
#      :result_stdout => "value for result_stdout",
#      :result_stderr => "value for result_stderr"
    }
  end

  it "should create a new instance given valid attributes" do
    SpecialGem.create!(@valid_attributes)
  end
end
