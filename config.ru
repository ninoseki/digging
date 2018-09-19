# frozen_string_literal: true

require "bundler/setup"
require "require_all"
require "sinatra"

require_all "app"

run MainApp
