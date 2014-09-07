xml.instruct!
xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do
  xml.url do
    xml.loc root_url
    xml.changefreq("hourly")
    xml.priority "1.0"
  end
  xml.url do
    xml.loc("http://www.advlo.com/adventures?region=Asia")
    xml.changefreq("hourly")
    xml.priority "0.9"
  end
  xml.url do
    xml.loc("http://www.advlo.com/adventures/info")
    xml.changefreq("hourly")
    xml.priority "0.9"
  end
  xml.url do
    xml.loc("http://www.advlo.com/adventures/request")
    xml.changefreq("hourly")
    xml.priority "0.9"
  end
  xml.url do
    xml.loc("http://www.advlo.com/users/sign_up")
    xml.changefreq("hourly")
    xml.priority "0.9"
  end
  xml.url do
    xml.loc("http://www.advlo.com/adventures?country=United%20States")
    xml.changefreq("hourly")
    xml.priority "0.9"
  end
  xml.url do
    xml.loc("http://www.advlo.com/adventures?region=Latin-America")
    xml.changefreq("hourly")
    xml.priority "0.9"
  end
  xml.url do
    xml.loc("http://www.advlo.com/adventures?region=Asia")
    xml.changefreq("hourly")
    xml.priority "0.9"
  end
  xml.url do
    xml.loc("http://www.advlo.com/adventures?country=Ecuador")
    xml.changefreq("hourly")
    xml.priority "0.9"
  end
  xml.url do
    xml.loc("http://www.advlo.com/adventures?country=Costa%20Rica")
    xml.changefreq("hourly")
    xml.priority "0.9"
  end
  @adventures.each do |adv|
    xml.url do
      xml.loc adventure_path(adv.slug)
      xml.changefreq("daily")
      xml.priority "0.8"
    end
  end
end