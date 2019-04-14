require_relative 'boot'

require 'rails/all'

require "action_controller/railtie"
require "active_record/railtie"
require "action_view/railtie"
require "graphql/client/railtie"
require "graphql/client/http"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RedshiftGraphqlClientRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end

  HTTPAdapter = GraphQL::Client::HTTP.new("http://localhost:4000/graphql") do
    def headers(context)
      # unless token = context[:access_token] || Application.secrets.github_access_token
      #   # $ GITHUB_ACCESS_TOKEN=abc123 bin/rails server
      #   #   https://help.github.com/articles/creating-an-access-token-for-command-line-use
      #   fail "Missing GitHub access token"
      # end

      # {
      #   "Authorization" => "Bearer #{token}"
      # }
      {}
    end
  end

  Schema = GraphQL::Client.load_schema(HTTPAdapter)

  Client = GraphQL::Client.new(
    schema: Schema,
    execute: HTTPAdapter
  )

  Application.config.graphql.client = Client
end
