require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Post do
  describe 'when saving' do
    it 'should bitch if title, zone or text is null' do
      post = Post.new
      post.save
      ['title', 'zone', 'text'].each do |col|
        post.errors[col].should_not be_nil
      end
    end
    
    it 'should bitch if timezone is not found by tzinfo' do
      post = Factory.build :post
      post.zone = 'Mars'
      post.save
      post.errors['zone'].should_not be_nil
    end
    
    it "generates a slug" do
      post = Factory :post, :title => 'Foo Bar Inc'
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
    
    it 'can build a montage with 3 pics' do
      File.exists?(APP_ROOT/'public'/'posts'/@post.id/'montage.png').should == true
    end
    
    it 'adds a montage to the first paragraph of the body if one exists' do
      @post.save
      @post.body.should match(/<a href/)
    end
    
    it "deletes a post's montage when the post is destroyed" do
      @post.destroy
      @post.montage_exists?.should == false
    end
  end
  
  describe '#location_from_time' do
    # Proves it works, kthxbye
    it 'should return "Sydney to Argentina" for 20th of May, around noon, Sydney time' do
      post = Factory :post, :created_at => Time.parse('Wed May 20 01:58:50 UTC 2009')
      post.location_from_time.should == 'Sydney to Argentina'
    end
  end
  
  
end