require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AppsController do

  #Delete this example and add some real ones
  it "should use AppsController" do
    controller.should be_an_instance_of(AppsController)
  end

end

describe AppsController do
  fixtures :users, :apps
  
  describe "as children of a user, handling create request" do
    it "should deny if not logged in" do
      create_app
      response.should redirect_to("/login")
    end
  
    it "should create app" do
      lambda {
        login_as(:quentin)
        create_app(users(:quentin).id)
        response.should be_redirect        
      }.should change(App, :count).by(1)
    end

    it "should not create app if different user" do
      lambda {
        login_as(:aaron)
        create_app(users(:quentin).id)
        response.should be_redirect        
      }.should change(App, :count).by(0)
    end

    it "should not create app if name duplicated" do
      login_as(:quentin)
      create_app(users(:quentin).id)
      lambda {
        login_as(:aaron)
        create_app(users(:aaron).id)
        response.should be_redirect
      }.should change(App, :count).by(0)
    end
    
    it "should create app of different user if user is admin" do
      lambda {
        login_as(:admin)
        create_app(users(:quentin).id)
        response.should be_redirect        
      }.should change(App, :count).by(1)
    end
  end
  
  
  describe "as children of a user, handling new update, and edit request" do
    [:new, :edit, :update].each do |action|
      it "should be success, against #{action}" do
        login_as(:quentin)
        requester(action)
        if action==:update
          response.should redirect_to(user_app_path(users(:quentin), 1))
        else
          response.should be_success
          response.should render_template("apps/#{action}")        
        end
      end
      it "should not be success when different user, against #{action}" do
        login_as(:aaron)
        requester(action)
        response.should redirect_to(login_path)
      end

      it "should not be success when logged in as admin, against #{action}" do
        login_as(:admin)
        requester(action)
        if action==:update
          response.should redirect_to(user_app_path(users(:quentin), 1))
        else
          response.should be_success
          response.should render_template("apps/#{action}")        
        end
      end
    end
  end

  def requester(action)
    case action
    when :update
      post :update, :user_id => users(:quentin).id, :id=> 1, :app => valid_app_attributes
    when :new
      get action, :user_id => users(:quentin).id, :id => 1
    when :edit
      get action, :user_id => users(:quentin).id, :id => 1
    end    
  end
  
  def valid_app_attributes
    { :name => 'hoge', :description => 'a hoge app'}
  end

  def create_app(user_id=1, app_options = {})
    post :create, :user_id => user_id, :app => valid_app_attributes.merge(app_options)
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
