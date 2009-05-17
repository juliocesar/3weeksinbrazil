require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Photo do
  describe "on #initialize" do
    it "raises an exception if argument does not exist" do
      lambda do
        Photo.new 'odkpaksdoapsd'
      end.should raise_error(Exception)
    end
    
    it "raises an exception if argument is not an image" do
      FileUtils.touch '/tmp/omg.txt'
      lambda do
        Photo.new '/tmp/omg.txt'
      end.should raise_error(Exception)
    end
    
    it "generates a polaroid on #build_polaroid" do
      post = create_post('foo_post')
      photo = post.photos.first
      photo.polaroid!
      photo.polaroid_exists?.should == true
    end

    it "skips generating a polaroid for a picture that already exists on #build_polaroid" 
    
    it "places a symlink for both the original and the polaroid inside the public directory"
    
    it "removes all symlinks on #delete" 
    
    after do
      FileUtils.rm_f '/tmp/omg.txt'
    end
  end
end