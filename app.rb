require 'haml'

# HELPERS
def image_tag(image, options = {})
  # Get image filename (but remove @1x and @2x resolution suffixes)
  image_name = image.gsub(/@[1-2]x/,'')

  # Set image source
  options[:src] = image

  # Set image srcset (if image filename contains @1x)
  if image.include? "@1x"
    options[:srcset] = "#{image} 1x, #{image.sub("@1x", "@2x")} 2x"
  end

  # Set height and width
  if options[:size]
    options[:width] = options[:size].split("x")[0]
    options[:height] = options[:size].split("x")[1]
    options.delete(:size)
  end

  # Set fallback alt text using image name
  # (only use this if image has no :alt text)
  unless options[:alt]
    options[:alt] = File.basename(image_name,File.extname(image_name))
  end

  # Disable normal image src if lazy loading image
  if options[:lazy] == "true"
      options["data-src"] = options[:src]
      options.delete(:src)
  end

  # Insert attributes into image tag
  attributes = " " + options.map{|k,v| k.to_s + "=" + '"' + v + '" '}.join(" ")
  "<img " + attributes + ">"
end

def link_to(text, url, options = {})
  unless options.empty?
    attributes = " " + options.map{|k,v| k.to_s + "=" + '"' + v + '" '}.join(" ")
  else
    attributes = ""
  end
  "<a href=#{url}" + attributes + ">#{text}</a>"
end

# APP
class SDRuby < Sinatra::Base

  # CONFIG

  # Use double-quoted attributes
  set :haml, {format: :html5, attr_wrapper: '"'}

  # Store views in /views
  set :views, File.dirname(__FILE__) + "/views"

  # Configure development environment
  configure :development do
    set :show_exceptions, true
  end

  # Configure all environments
  configure do
    # Initialize sprockets
    set :environment, Sprockets::Environment.new

    # Set public folder
    set :static, true

    # Set asset paths
    environment.append_path "assets/images"
    environment.append_path "assets/javascripts"
    environment.append_path "assets/stylesheets"

    # Load assets
    get "/assets/*" do
      env["PATH_INFO"].sub!("/assets", "")
      settings.environment.call(env)
    end
  end

  # Redirect requests to https in production
  before do
    if ENV["RACK_ENV"] == "production"
      redirect request.url.sub('http', 'https') unless request.secure?
    end
  end

  # ROUTES

  # Homepage
  get '/' do
    @title = "SD Ruby"

    haml :index
  end

  # Code of Conduct
  get '/conduct' do
    @title = "Code of Conduct"

    haml :conduct
  end

  # Organizers
  get '/organizers' do
    @title = "Meet the Organizers"

    haml :organizers
  end
end
