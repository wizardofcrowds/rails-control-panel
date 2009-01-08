require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe App do
  before(:each) do
    @valid_attributes = {
      :user_id => "1",
      :name => "value_for_name",
      :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    App.create!(@valid_attributes)
  end
  
  it "should not miss name to create a new instance given valid attributes" do
    app = App.create(@valid_attributes.except(:name))
    app.should_not be_valid
  end

  it "should not miss name to create a new instance given valid attributes" do
    app = App.create(@valid_attributes.except(:user_id))
    app.should_not be_valid
  end
  
  it "should have unique name" do
    App.create!(@valid_attributes)
    app = App.create(:user_id=>2, :name=>"value_for_name")
    app.should_not be_valid
  end

end

describe 'disallows illegitimate app names:' do
  ["tab\t", "newline\n",
   "Iñtërnâtiônàlizætiøn hasn't happened to ruby 1.8 yet",
   'semicolon;', 'quote"', 'tick\'', 'backtick`', 'percent%', 'plus+', 'space '].each do |name_str|
    it "'#{name_str}'" do
      lambda do
        app = App.create(:name => name_str)
        app.errors.on(:name).should_not be_nil
      end.should_not change(App, :count)
    end
  end
  
  it "should not allow controller to create sample-loginname name of app"
end
