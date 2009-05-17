require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Post do
  describe 'when saving' do
    it 'should bitch if title, zone or text is null' do
      post = Post.new :skip_montage => true
      post.save
      ['title', 'zone', 'text'].each do |col|
        post.errors[col].should_not be_nil
      end
    end
    
    it 'should bitch if timezone is not found by tzinfo' do
      post = Factory.build :post, :skip_montage => true
      post.zone = 'Mars'
      post.save
      post.errors['zone'].should_not be_nil
    end
    
    it "generates a slug" do
      post = Factory :post, :title => 'Foo Bar Inc', :skip_montage => true
      post.slug.should == 'Foo Bar Inc'.to_url
    end
  end
  
  describe 'montages' do
    before do      
      @post = Factory :post
      3.times { Factory :photo, :post => @post }
      @post.skip_montage = false
      @post.save
    end
    
    it 'builds a polaroid (or a bunch) with one or more pictures' do
      File.exists?(APP_ROOT/'public'/'posts'/@post.id/'montage.png').should == true
    end
    
    it 'adds the polaroid to the first paragraph of the body if one exists' do
      @post.save
      p = (Hpricot(@post.body)/'p').first
      p.to_s.should match(/<a href/)
    end
    
    it "deletes a post's polaroid(s) when the post is destroyed" do
      @post.destroy
      @post.montage_exists?.should == false
    end
  end
  
  describe "creating" do
    it "creates a new post from a directory" 
    it "updates an existing post from a directory"
  end
  
  describe '#location_from_time' do
    # Proves it works, kthxbye
    it 'should return "Sydney to Argentina" for 20th of May, around noon, Sydney time' do
      post = Factory :post, :created_at => Time.parse('Wed May 20 01:58:50 UTC 2009'), :skip_montage => true
      post.location_from_time.should == 'Sydney to Argentina'
    end
  end
  
  
end