require "builder"

set :layout, :docs

activate :directory_indexes
activate :autoprefixer

set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true, :with_toc_data => true
set :markdown_engine, :redcarpet
configure :development do
  set :debug_assets, true
end

configure :build do
  activate :minify_css
  activate :minify_javascript
end

activate :alias

helpers do
  def active_link_to(caption, url, options = {})
    if current_page.url == "#{url}/"
      options[:class] = "doc-item-active"
    end

    link_to(caption, url, options)
  end
end
set :index_file, "index.html"

set :css_dir, 'assets/css'
set :images_dir, 'assets/img'
set :js_dir, 'assets/js'

page "/index.html", :layout => false
page "intro/*", :layout => "intro"
page "download/*", :layout => "intro"
page "getting_started/*", :layout => "intro"
page "docs/*", :layout => "docs"
page "armada_components/*", :layout => "docs"

set :build_dir, "/opt/www/www"
