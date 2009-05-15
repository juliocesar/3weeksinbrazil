require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Post do
    
  before do
    FileUtils.mkdir_p POSTS_ROOT
    FileUtils.mkdir POSTS_ROOT/'foo_post'
    FileUtils.touch POSTS_ROOT/'foo_post'/'text'
    FileUtils.touch POSTS_ROOT/'foo_post'/'body'
  end
  
  it "returns all valid posts in APP_ROOT/posts with #all" do
    Post.all.should == ['foo_post']
  end
  
  it "returns an instance of Post on #open" do
    Post.open('foo_post').should be_an_instance_of(Post)
  end
  
  it "returns an array of Photos on #photos" do
    FileUtils.mkdir POSTS_ROOT/'foo_post'/'photos'
    FileUtils.touch POSTS_ROOT/'foo_post'/'photos'/'photo.jpg'
    post = Post.open('foo_post')
    post.photos.should_not be_empty # a lot less than ideal
  end
  
  it "returns paginated results on Post#all"
  
  it "removes the post directory on #delete" # do
  #     post = Post.open('foo_post')
  #     post.delete!
  #     File.directory?(POSTS_ROOT/'foo_post').should == false
  #   end
  
  it "removes the symlink to the post's montage on #delete"
  
  after do
    FileUtils.rm_rf POSTS_ROOT
  end
  
end