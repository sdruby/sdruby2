require 'haml'
require_relative 'helpers'

class SDRuby < Sinatra::Base
  helpers Helpers

  # APP SETTINGS

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

  # Use double-quoted attributes
  set :haml, {format: :html5, attr_wrapper: '"'}

  # Store views in /views
  set :views, File.dirname(__FILE__) + "/views"

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
