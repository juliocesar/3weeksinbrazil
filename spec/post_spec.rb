require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Post do
    
  before do
    FileUtils.mkdir_p POSTS_ROOT
  end
  
  it "should return all valid posts in APP_ROOT/posts with #all" do
    FileUtils.mkdir POSTS_ROOT/'foo_post'
    FileUtils.touch POSTS_ROOT/'foo_post'/'text'
    FileUtils.touch POSTS_ROOT/'foo_post'/'body'
    Post.all.should == ['foo_post']
  end
  
  after do
    FileUtils.rm_rf POSTS_ROOT
  end
  
end