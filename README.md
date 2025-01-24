# SD Ruby

This is the current website for SD Ruby.

This site includes:
- The SD Ruby logo
- Meeting information
- Social links:
  - Meetup
  - Slack
  - Google Groups
  - YouTube
  - Twitter

The website is built with:
- Sinatra (app)
- HAML (views)
- Bulma (css)

## Getting started

### Clone the app
1. `cd Sites/` (or wherever you like to store projects locally)
2. `git clone git@github.com:sdruby/sdruby2.git`

### Configure the app and bundle install
1. Switch to Ruby 3.3.7 with the Ruby version manager of your choice (this
should happen automatically from the `.ruby-version` file)
4. Bundle your gem dependencies: `bundle install`.

### Launch the app
1. Run `bundle exec foreman start -f Procfile.dev` to launch the app.
