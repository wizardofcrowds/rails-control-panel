require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AppsController do

  #Delete this example and add some real ones
  it "should use AppsController" do
    controller.should be_an_instance_of(AppsController)
  end

end


describe AppsController do
  describe "as children of a user, route generation" do
    it "should route apps's 'index' action correctly" do
      route_for(:controller => 'apps', :action => 'index', :user_id=>1).should == "/users/1/apps"
    end
    it "should route apps's 'show' action correctly" do
      route_for(:controller => 'apps', :action => 'show', :id => '1', :user_id=>1).should == "/users/1/apps/1"
    end
    
    it "should route apps's 'edit' action correctly" do
      route_for(:controller => 'apps', :action => 'edit', :id => '1', :user_id=>1).should == "/users/1/apps/1/edit"
    end
    
    it "should route apps's 'update' action correctly" do
      route_for(:controller => 'apps', :action => 'update', :id => '1', :user_id=>1).should == "/users/1/apps/1"
    end
    
    it "should route apps's 'destroy' action correctly" do
      route_for(:controller => 'apps', :action => 'destroy', :id => '1', :user_id=>1).should == "/users/1/apps/1"
    end
  end
  
  describe "route recognition" do
    it "should generate params for apps's index action from GET /users/1/apps" do
      params_from(:get, '/users/1/apps').should == {:controller => 'apps', :action => 'index', :user_id=>"1"}
    end
    
    it "should generate params for apps's new action from GET /users/1/apps" do
      params_from(:get, '/users/1/apps/new').should == {:controller => 'apps', :action => 'new', :user_id=>"1"}
    end
    
    it "should generate params for apps's create action from POST /users/1/apps" do
      params_from(:post, '/users/1/apps').should == {:controller => 'apps', :action => 'create', :user_id=>"1"}
    end
    
    it "should generate params for apps's show action from GET /users/1/apps/1" do
      params_from(:get , '/users/1/apps/1').should == {:controller => 'apps', :action => 'show', :id => '1', :user_id=>"1"}
    end
    
    it "should generate params for apps's edit action from GET /users/1/apps/1/edit" do
      params_from(:get , '/users/1/apps/1/edit').should == {:controller => 'apps', :action => 'edit', :id => '1', :user_id=>"1"}
    end
    
    it "should generate params {:controller => 'apps', :action => update', :id => '1'} from PUT /users/1/apps/1" do
      params_from(:put , '/users/1/apps/1').should == {:controller => 'apps', :action => 'update', :id => '1', :user_id=>"1"}
    end
    
    it "should generate params for apps's destroy action from DELETE /users/1/apps/1" do
      params_from(:delete, '/users/1/apps/1').should == {:controller => 'apps', :action => 'destroy', :id => '1', :user_id=>"1"}
    end
  end
  
end
