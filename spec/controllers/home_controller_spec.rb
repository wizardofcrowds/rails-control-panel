require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController, " handling a GET request" do

  specify "{ :controller => 'home', :action => 'index' } to /" do
    route_for(:controller => "home", :action => "index").should eql("/")
  end

  it "should be successful" do
    get :index
    response.should be_success
  end
  
  it "should render index" do
    get :index
    response.should render_template("index") 
  end
  
end
