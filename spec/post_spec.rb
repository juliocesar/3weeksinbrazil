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
  end
  
  describe '#location_from_time' do
    # Proves it works, kthxbye
    it 'should return "Sydney to Argentina" for 20th of May, around noon, Sydney time' do
      post = Factory :post, :created_at => Time.parse('Wed May 20 01:58:50 UTC 2009')
      post.location_from_time.should == 'Sydney to Argentina'
    end
  end
  
  
end