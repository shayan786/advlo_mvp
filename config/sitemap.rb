Sitemap::Generator.instance.load :host => "beta.advlo.com" do
  path :root, :priority => 1
  literal "http://blog.advlo.com/"
  literal "/terms"
  literal "/adventures/info"
  resources :adventures, :objects => proc { Adventure.approved }
end