require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/hoge/name:string" do
  before(:each) do
    render 'hoge/name:string'
  end
  
  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/hoge/name:string])
  end
end
