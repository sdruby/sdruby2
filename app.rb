require 'haml'

# VIEWS
set :haml, :format => :html5, :attr_wrapper => '"'
set :views, File.dirname(__FILE__) + "/views"

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

  # Configure for development environment
  configure :development do
    set :show_exceptions, true
  end

  # Configure for all environments
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

  # ROUTES

  # Homepage
  get '/' do
    @base_url = "#{request.scheme}://#{request.host}"
    if self.class.development?
      @base_url += ":3000"
    end

    haml :index
  end
end