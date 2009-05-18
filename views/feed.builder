xml.instruct! :xml, :version => '2.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "3 weeks in Brazil"
    xml.description "3 weeks in the south of Brazil"
    xml.link "http://3weeksinbrazil.com"
        
    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link "http://3weeksinbrazil.com/#{post.slug}"
        xml.description post.text
        xml.pubDate Time.parse(post.created_at.to_s).rfc822()
        xml.guid "http://3weeksinbrazil.com/#{post.slug}"
      end
    end
  end
end

