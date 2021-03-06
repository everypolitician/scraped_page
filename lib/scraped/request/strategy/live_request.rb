require 'scraped/request/strategy'
require 'open-uri'

module Scraped
  class Request
    class Strategy
      class LiveRequest < Strategy
        def response
          log "Fetching #{url}"
          response = open(url, headers)
          {
            status:  response.status.first.to_i,
            headers: response.meta,
            body:    response.read,
          }
        end

        private

        def log(message)
          warn "[#{self.class}] #{message}" if ENV.key?('VERBOSE')
        end
      end
    end
  end
end
