require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Post do
  describe 'when saving' do
    it 'should bitch if title, zone, or body is null' do
      post = Post.new
      post.save
      ['title', 'zone', 'body'].each do |col|
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
    
    it "builds a montage with 3 pics" do
      post = Factory :post
      3.times { Factory :photo, :post => post }
      post.skip_montage = false
      post.build_montage
      File.exists?("#{APP_ROOT}/public/posts/#{post.id}/montage.png").should == true
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