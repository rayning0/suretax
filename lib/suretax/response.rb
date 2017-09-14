require "json"

module Suretax
  class Response
    attr_reader :response, :body, :status, :api

    def initialize(api_response)
      @response = api_response
      sanitized_body = remove_xml_brackets(api_response.body)

      if sanitized_body == "invalid request"
        invalid_request_response(sanitized_body)
      else
        valid_request_response(sanitized_body)
      end
    end

    def success?
      status == 200
    end

    private

    def valid_request_response(sanitized_body)
      @body = JSON.parse(sanitized_body)
      @api = Api::Response.new(@body)
      @status = map_response_code_to_http_status(api.status)
      log_response
      self
    end

    def invalid_request_response(sanitized_body)
      @body = sanitized_body
      @status = 400
      @api = nil
      log_response
      self
    end

    def extract_json_from_urlencoded_string_regex
      # http://rubular.com/r/0w73fy4Ldk
      /\A<\?xml.*<string[^>]+>(?<json_string>.+)<\/string>\z/m
    end

    def remove_xml_brackets(response_string)
      if matches = response_string.match(extract_json_from_urlencoded_string_regex)
        matches["json_string"]
      else
        response_string
      end
    end

    def map_response_code_to_http_status(api_status_code)
      case api_status_code
      when "9999"
        200
      when "9001"
        409
      else
        400
      end
    end

    def log_response
      puts "\nSureTax Response Received:"
      pp body
    end

    def logger
      configuration.logger
    end

    def configuration
      Suretax.configuration
    end
  end
end
