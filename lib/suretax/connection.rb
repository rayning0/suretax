require "uri"
require "json"

module Suretax
  class Connection
    attr_accessor :headers

    def initialize(args = {})
      @link = Excon.new(args[:base_url] || api_host)
      @headers = { "Content-Type" => "application/x-www-form-urlencoded" }
    end

    def post(body = {})
      Response.new(@link.post(path: post_path,
                              headers: headers,
                              body: "request=#{encode_body(body)}"))
    end

    def cancel(body = {})
      Response.new(@link.post(path: cancel_path,
                              headers: headers,
                              body: "requestCancel=#{encode_body(body)}"))
    end

    private

    def encode_body(request_hash)
      json_body = JSON.generate(request_hash)
      URI.encode_www_form_component(json_body)
    end

    def post_path
      configuration.request_path
    end

    def cancel_path
      configuration.cancel_path
    end

    def api_host
      configuration.base_url
    end

    def configuration
      Suretax.configuration
    end
  end
end
