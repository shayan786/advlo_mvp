base_url = "http://#{request.host_with_port}"
xml.instruct! :xml, :version=>'1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  xml.url{
      xml.loc("http://www.advlo.com")
      xml.changefreq("weekly")
      xml.priority(1.0)
  }
  xml.url{
      xml.loc("http://www.advlo.com/adventures")
      xml.changefreq("daily")
      xml.priority(0.9)
  }
  xml.url{
      xml.loc("http://www.advlo.com/adventures?region=North-America")
      xml.changefreq("daily")
      xml.priority(0.9)
  }
  xml.url{
      xml.loc("http://www.advlo.com/adventures?region=Latin-America")
      xml.changefreq("daily")
      xml.priority(0.9)
  }
  xml.url{
      xml.loc("http://www.advlo.com/adventures?region=Asia")
      xml.changefreq("daily")
      xml.priority(0.9)
  }
  @adventures.each do |p|
    xml.url {
      xml.loc("http://www.advlo.com/adventures/#{p.slug}")
      xml.changefreq("weekly")
      xml.priority(0.5)
    }
  end
end