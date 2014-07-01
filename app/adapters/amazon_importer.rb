class AmazonImporter
  require 'nokogiri'
  require 'open-uri'

  def self.importreviews(asin)
    #puts "#{asin}"

    # Create new project
    @project = Project.new
    @project.title = "#{asin}"
    @project.save

    # Counting variable
    page = 1

    # Iterate through pages
    begin
      url = "http://www.amazon.com/product-reviews/#{asin}/?ie=UTF8&showViewpoints=0&pageNumber=#{page}&sortBy=bySubmissionDateAscending"
      doc = Nokogiri::HTML(open(url))

      new_reviews = 0

      doc.css("#productReviews td > a[name]").each do |review_html|
        @html = review_html
        @div = review_html.next_element.next_element

        @note = @project.notes.new

        @note.text = @div.css(".reviewText").first.content.strip

        @note.save

        new_reviews += 1
      end

      page += 1

    end until new_reviews == 0

  end
end
