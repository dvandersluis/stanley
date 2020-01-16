require 'faraday'
require 'faraday/detailed_logger'
require 'faraday_middleware'
require 'zeitwerk'

module Stanley
  class Error < StandardError; end
  # Your code goes here...

  def self.loader
    @loader ||= Zeitwerk::Loader.for_gem.tap(&:enable_reloading)
  end
end

Stanley.loader.setup
