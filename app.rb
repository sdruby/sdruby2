require "haml"
require "sinatra/base"
require_relative "helpers"

class SDRuby < Sinatra::Base
  helpers Helpers

  # APP SETTINGS

  # Redirect requests to https in production
  before do
    if ENV["RACK_ENV"] == "production"
      redirect request.url.sub("http", "https") unless request.secure?
    end
  end

  # Configure haml
  set :haml, {format: :html5, attr_quote: '"', escape_html: false}

  # Store views in /views
  set :views, Proc.new { File.join(root, "views") }

  # ROUTES

  # Homepage
  get "/" do
    @title = "SD Ruby"

    haml :index
  end

  # Code of Conduct
  get "/conduct" do
    @title = "Code of Conduct"

    haml :conduct
  end

  # Organizers
  get "/organizers" do
    @title = "Meet the Organizers"

    haml :organizers
  end
end
