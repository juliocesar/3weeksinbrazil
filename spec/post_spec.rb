require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Post do
  describe 'when saving' do
    it "should bitch if title, zone, or body is null" do
      post = Post.new
      post.save
      ['title', 'zone', 'body'].each do |col|
        post.errors[col].should_not be_nil
      end
    end
    
    it "should bitch if timezone is not found by tzinfo" do
      post = Factory.build :post
      post.zone = 'Mars'
      post.save
      post.errors['zone'].should_not be_nil
    end
  end
  
end