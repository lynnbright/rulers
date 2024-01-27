# frozen_string_literal: true

require "rulers/array"
require_relative "rulers/version"
require_relative "rulers/routing"

module Rulers
  class Error < StandardError; end

  class Application
    def call(env)
      if env["PATH_INFO"] == "/"
        # Playground1: Redirect to /quotes/a_quote
        return [302, {'Location' => "/quotes/a_quote"}, []]

        # Playground2: Return the contents of a known file
        # return [200, {'Content-Type' => 'text/html'}, [File.read("public/index.html")]]

        # Playground3: Look for a HomeController and its index action
        # controller = HomeController.new(env)
        # text = controller.send(:index)
        # [200, {'Content-Type' => 'text/html'}, [text]]
      end

      if env["PATH_INFO"] == "/favicon.ico"
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      begin
        klass, action = get_controller_and_action(env)
        controller = klass.new(env)
        text = controller.send(action)
        [200, {'Content-Type' => 'text/html'},
          [text]]
      rescue
        [500, {'Content-Type' => 'text/html'},
          ["Sorry, something went wrong!"]]
      end
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end
  end
end
