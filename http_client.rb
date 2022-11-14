# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

module CourierSDK 
  module Clients
    # Implements a HTTP based client
    class HttpClient
      CARRIER = 'courier'
      EXTERNAL_REQUEST_LOG_MESSAGE = 'Requesting External Service'
      SUCCESS_CODE = 200

      attr_reader :start_time, :end_time, :token, :merchant_country_code
      private :start_time, :end_time, :token, :merchant_country_code

      def initialize(token:, merchant_country_code:)
        @token = token
        @merchant_country_code = merchant_country_code
      end

      # rubocop:disable Metrics/AbcSize
      def request(request_body = nil)
        payload = request_verb == 'get' || request_verb == 'delete' ? nil : request_body.to_json

        @start_time = Time.now
        response = connection.send(request_verb, resource_path, payload) do |req|
          req.headers[:content_type] = 'application/json'
          req.headers[:authorization] = "Bearer #{token}"
        end
        @end_time = Time.now

        log(response)

        handle_response(payload, response)
      end
      # rubocop:enable Metrics/AbcSize

      def connection
        @connection ||= Faraday.new(request_url) do |conn|
          conn.response :logger, logger, logger_options
          conn.adapter Faraday.default_adapter
        end
      end

      def parsed_response(response)
        return {} if response.body.nil? || response.body.empty?

        JSON.parse(response.body)
      end

      def logger
        @logger ||= AramexAuNzSdk.logger
      end

      private

      def action
        'NotImplemented'
      end

      def request_verb
        'post'
      end

      def log(response)
        result = {
          response_code: response.status,
          duration: end_time - start_time
        }

        case response.status
        when 200..399
          api_log(result.merge!(success: true))
        else
          api_log(result.merge!(success: false, error_response: response.body))
        end
      end

      def logger_options
        debug_mode = !AramexAuNzSdk.production?

        { headers: debug_mode, bodies: debug_mode }
      end

      def api_log(result, log_level: :info)
        log_entry = default_log.merge(duration: result[:duration],
                                      response_code: result[:response_code],
                                      success: result[:success])

        unless result[:success]
          redacted_response = redact(string: result[:error_response],
                                     redactions: redact_strings)
          log_entry[:error_response] = redacted_response
          log_level = :error
        end
        logger.send(log_level, log_entry.to_json)
      end

      def redact_strings
        []
      end

      def default_log
        time_now = Time.now
        {
          action: action,
          carrier: CARRIER,
          message: EXTERNAL_REQUEST_LOG_MESSAGE,
          request_verb: request_verb,
          timestamp: time_now.iso8601,
          url: request_url,
          utc_timestamp: time_now.utc.iso8601
        }
      end

      def request_url
        AramexAuNzSdk.base_url(merchant_country_code)
      end

      def redact(string:, redactions:)
        redacted_string = string.dup
        redactions.each { |redaction| redacted_string.gsub!(redaction, '******') }
        redacted_string
      end
    end
  end
end
