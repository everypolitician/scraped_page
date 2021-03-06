module Scraped
  class HTML < Scraped::Document
    private

    def initialize(noko: nil, **args)
      super(**args)
      @noko = noko
    end

    def noko
      @noko ||= Nokogiri::HTML(response.body)
    end

    def fragment(mapping)
      noko_fragment, klass = mapping.to_a.first
      klass.new(noko: noko_fragment, response: response)
    end
  end
end
