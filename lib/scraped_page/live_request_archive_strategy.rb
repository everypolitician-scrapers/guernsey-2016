class ScrapedPage
  class LiveRequestArchiveStrategy < LiveRequestStrategy
    private

    def response
      super.tap do |response|
        # Archive.new(response).store
      end
    end
  end
end
