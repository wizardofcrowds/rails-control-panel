require File.dirname(__FILE__) + '/../spec_helper'
  
# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe UsersController do
  fixtures :users

  it 'does not allow creating users if not login' do
    lambda do
      create_user
      response.should be_redirect
    end.should_not change(User, :count)
  end

  it 'does not allowcreating users if not admin' do
    login_as(:aaron)
    lambda do
      create_user
      response.should be_redirect
    end.should_not change(User, :count)
  end

  it 'allows to create user if admin' do
    login_as(:admin)
    lambda do
      create_user
      response.should redirect_to(user_path(User.find_by_login('quire')))
    end.should change(User, :count).by(1)
    current_user.should eql(users(:admin))
  end

  it 'requires login to create users' do
    login_as(:admin)
    lambda do
      create_user(:login => nil)
      assigns[:user].errors.on(:login).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'requires password to create users' do
    login_as(:admin)
    lambda do
      create_user(:password => nil)
      assigns[:user].errors.on(:password).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'requires password confirmation to create users' do
    login_as(:admin)
    lambda do
      create_user(:password_confirmation => nil)
      assigns[:user].errors.on(:password_confirmation).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end

  it 'requires email to create user' do
    login_as(:admin)
    lambda do
      create_user(:email => nil)
      assigns[:user].errors.on(:email).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  
  
  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
  end
end

describe UsersController, "handling index request" do
  fixtures :users
  
  it "should deny if not logged in" do
    get :index
    response.should redirect_to(login_path)
  end
  
  it "should deny if not admin" do
    login_as(:aaron)
    get :index
    response.should redirect_to(login_path)
  end
  
  it "should allow if admin" do
    login_as(:admin)
    get :index
    response.should be_success
    response.should render_template("users/index")
  end
end

describe UsersController, "handling new request" do
  fixtures :users
  
  it "should deny if not logged in" do
    get :new
    response.should redirect_to(login_path)
  end
  
  it "should deny if not admin" do
    login_as(:aaron)
    get :new
    response.should redirect_to(login_path)
  end
  
  it "should allow if admin" do
    login_as(:admin)
    get :new
    response.should be_success
    response.should render_template("users/new")
  end
end

describe UsersController, "handling show and edit, update request" do
  fixtures :users
  
  ["show", "edit", "update"].each do |action|
  
    it "should deny if not logged in, against #{action}" do
      get action, :id=>users(:aaron).id
      response.should redirect_to(login_path)
    end
  
    it "should deny if different user, against #{action}" do
      login_as(:aaron)
      get action, :id=>users(:admin).id
      response.should redirect_to(root_path)
    end
  
    it "should allow if admin, against #{action}" do
      login_as(:admin)
      get action, :id=>users(:aaron)
      response.should action=="update" ? redirect_to(edit_user_path(users(:aaron))) : be_success
      response.should render_template("users/#{action}") unless action=="update"
    end
  
    it "should redirect to index if the requested by admin user does not exists, against #{action}" do
      login_as(:admin)
      get action, :id=>100
      response.should redirect_to(root_path)
    end
  end
  
end


describe UsersController do
  describe "route generation" do
    it "should route users's 'index' action correctly" do
      route_for(:controller => 'users', :action => 'index').should == "/users"
    end
    
    it "should route users's 'new' action correctly" do
      route_for(:controller => 'users', :action => 'new').should == "/signup"
    end
    
    it "should route {:controller => 'users', :action => 'create'} correctly" do
      route_for(:controller => 'users', :action => 'create').should == "/register"
    end
    
    it "should route users's 'show' action correctly" do
      route_for(:controller => 'users', :action => 'show', :id => '1').should == "/users/1"
    end
    
    it "should route users's 'edit' action correctly" do
      route_for(:controller => 'users', :action => 'edit', :id => '1').should == "/users/1/edit"
    end
    
    it "should route users's 'update' action correctly" do
      route_for(:controller => 'users', :action => 'update', :id => '1').should == "/users/1"
    end
    
    it "should route users's 'destroy' action correctly" do
      route_for(:controller => 'users', :action => 'destroy', :id => '1').should == "/users/1"
    end
  end
  
  describe "route recognition" do
    it "should generate params for users's index action from GET /users" do
      params_from(:get, '/users').should == {:controller => 'users', :action => 'index'}
      params_from(:get, '/users.xml').should == {:controller => 'users', :action => 'index', :format => 'xml'}
      params_from(:get, '/users.json').should == {:controller => 'users', :action => 'index', :format => 'json'}
    end
    
    it "should generate params for users's new action from GET /users" do
      params_from(:get, '/users/new').should == {:controller => 'users', :action => 'new'}
      params_from(:get, '/users/new.xml').should == {:controller => 'users', :action => 'new', :format => 'xml'}
      params_from(:get, '/users/new.json').should == {:controller => 'users', :action => 'new', :format => 'json'}
    end
    
    it "should generate params for users's create action from POST /users" do
      params_from(:post, '/users').should == {:controller => 'users', :action => 'create'}
      params_from(:post, '/users.xml').should == {:controller => 'users', :action => 'create', :format => 'xml'}
      params_from(:post, '/users.json').should == {:controller => 'users', :action => 'create', :format => 'json'}
    end
    
    it "should generate params for users's show action from GET /users/1" do
      params_from(:get , '/users/1').should == {:controller => 'users', :action => 'show', :id => '1'}
      params_from(:get , '/users/1.xml').should == {:controller => 'users', :action => 'show', :id => '1', :format => 'xml'}
      params_from(:get , '/users/1.json').should == {:controller => 'users', :action => 'show', :id => '1', :format => 'json'}
    end
    
    it "should generate params for users's edit action from GET /users/1/edit" do
      params_from(:get , '/users/1/edit').should == {:controller => 'users', :action => 'edit', :id => '1'}
    end
    
    it "should generate params {:controller => 'users', :action => update', :id => '1'} from PUT /users/1" do
      params_from(:put , '/users/1').should == {:controller => 'users', :action => 'update', :id => '1'}
      params_from(:put , '/users/1.xml').should == {:controller => 'users', :action => 'update', :id => '1', :format => 'xml'}
      params_from(:put , '/users/1.json').should == {:controller => 'users', :action => 'update', :id => '1', :format => 'json'}
    end
    
    it "should generate params for users's destroy action from DELETE /users/1" do
      params_from(:delete, '/users/1').should == {:controller => 'users', :action => 'destroy', :id => '1'}
      params_from(:delete, '/users/1.xml').should == {:controller => 'users', :action => 'destroy', :id => '1', :format => 'xml'}
      params_from(:delete, '/users/1.json').should == {:controller => 'users', :action => 'destroy', :id => '1', :format => 'json'}
    end
  end
  
  describe "named routing" do
    before(:each) do
      get :new
    end
    
    it "should route users_path() to /users" do
      users_path().should == "/users"
      formatted_users_path(:format => 'xml').should == "/users.xml"
      formatted_users_path(:format => 'json').should == "/users.json"
    end
    
    it "should route new_user_path() to /users/new" do
      new_user_path().should == "/users/new"
      formatted_new_user_path(:format => 'xml').should == "/users/new.xml"
      formatted_new_user_path(:format => 'json').should == "/users/new.json"
    end
    
    it "should route user_(:id => '1') to /users/1" do
      user_path(:id => '1').should == "/users/1"
      formatted_user_path(:id => '1', :format => 'xml').should == "/users/1.xml"
      formatted_user_path(:id => '1', :format => 'json').should == "/users/1.json"
    end
    
    it "should route edit_user_path(:id => '1') to /users/1/edit" do
      edit_user_path(:id => '1').should == "/users/1/edit"
    end
  end
  
end
