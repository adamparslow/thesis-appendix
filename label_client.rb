module Couriers
  module Courier 
    module Api
      class LabelClient < Couriers::Base::Api::Client
        include Client

        E2E_TEST_MOCK_SERVER_TNT_CONSIGNMENT_ENDPOINT = 'Webservices/Conservice/ConsignmentService.svc'.freeze

        def initialize(order)
          init_merchant_settings order.merchant.tnt_settings
          @order = order
          self.api_log_name = 'COURIER GET LABEL'
          self.request_verb = 'post'
          self.action = 'Label'
        end

        def request_body
          @request_body ||= Couriers::Courier::ConsignmentXml.new(@order, @username, @password,
                                                              @account_number, @sender_code).xml
        end

        def log_everything?(result = nil)
          false
        end

        def identifier
          @order.id
        end

        def soap_action
          ...
        end

        def build_url
          ...
        end

        def error_description(data)
          ...
        end

        def parse_response(data)
          ...
        end

        private

        def log_error(error_message, data)
          params = { klass: self.class.name,
                     api_log_name: api_log_name,
                     request_verb: request_verb,
                     response_code: response_code,
                     url: build_url,
                     duration: duration,
                     merchant_id: merchant_id,
                     courier_id: courier_id,
                     identifier: identifier,
                     request_body: request_body,
                     response: data,
                     error_message: error_message }

          ::Shippit::Logger.log(message: 'Get Label failed',
                                data: params,
                                level: :error,
                                redactions: log_redactions)
        end
      end
    end
  end
end
