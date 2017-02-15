require 'nokogiri'
require 'uri'

module Scraped
  class Response
    class Decorator
      class AbsoluteUrls < Decorator
        class AbsoluteUrl
          def initialize(base_url:, relative_url:)
            @base_url = base_url
            @relative_url = relative_url
          end

          def to_s
            unless relative_url.to_s.empty?
              URI.join(base_url, URI.encode(
                # To prevent encoded URLs from being encoded twice
                URI.decode(relative_url)
              ).gsub('[', '%5B').gsub(']', '%5D')).to_s
            end
          rescue URI::InvalidURIError
            relative_url
          end

          private

          attr_reader :base_url, :relative_url
        end

        def body
          Nokogiri::HTML(super).tap do |doc|
            doc.css('img').each { |img| img[:src] = absolute_url(img[:src]) }
            doc.css('a').each { |a| a[:href] = absolute_url(a[:href]) }
          end.to_s
        end

        private

        def absolute_url(relative_url)
          AbsoluteUrl.new(base_url: url, relative_url: relative_url).to_s
        end
      end
    end
  end
end
