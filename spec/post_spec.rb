require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Post do
    
  before do
    FileUtils.rm_rf POSTS_ROOT/'*'
    create_post('foo_post')
  end
  
  it "returns all valid posts in APP_ROOT/posts with #all" do
    Post.all.should have(1).instance_of(Post)
  end
  
  it "returns an instance of Post on #open" do
    Post.open('foo_post').should be_an_instance_of(Post)
  end
  
  it "returns paginated results on Post#all"
  
  describe "with Photos" do
    it "returns an array on #photos" do
      post = Post.open('foo_post')
      post.photos.should have(2).instances_of(Photo)
    end
    
    it "creates a stacked montage of polaroids on #stack_polaroids! and puts it on post_dir/public" do
      post = Post.open('foo_post')
      post.stack_polaroids!
      File.exists?(post.montage_path).should == true
    end
    
    it "symlinks a post's montage and photos onto a public directory on #publish!" do
      post = Post.open('foo_post')
      post.stack_polaroids!
      post.publish!
      File.directory?(APP_ROOT/'public'/post.name).should == true
      File.symlink?(APP_ROOT/'public'/post.name/'photos').should == true
      File.exists?(APP_ROOT/'public'/post.name/'montage.png').should == true
    end
    
    it "removes the symlink to the post's montage on #delete"
  end
  
  after do
    FileUtils.rm_rf POSTS_ROOT/'*'
  end
  
end