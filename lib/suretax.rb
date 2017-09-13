require "suretax/version"

require "suretax/concerns"

require "suretax/configuration"
require "suretax/connection"
require "suretax/response"
require "suretax/constants"
require "suretax/api"
require "suretax/get_tax"

require "money"

module Suretax
  class << self
    attr_accessor :configuration

    def configure
      yield(configuration)
    end
  end

  self.configuration ||= Configuration.instance
end
