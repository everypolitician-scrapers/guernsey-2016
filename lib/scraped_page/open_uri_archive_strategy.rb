class ScrapedPage
  class OpenURIArchiveStrategy < OpenURIStrategy
    private

    def response
      super.tap do |response|
        # Archive.new(response).store
      end
    end
  end
end
