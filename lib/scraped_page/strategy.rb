class ScrapedPage
  class Strategy
    MissingMethodError = Class.new(StandardError)

    def initialize(url)
      @url = url
    end

    def body
      raise MissingMethodError, "Strategy must provide '#body' method to return response body"
    end

    private

    attr_reader :url
  end
end
