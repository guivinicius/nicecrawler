require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'json'

class NiceCrawler
  attr_reader :base_url

  def initialize(url)
    fail 'url is required' if url.nil? || url.empty?

    @uri         = URI.parse(url)
    @base_url    = build_base_url
    @sitemap     = []
    @crawl_queue = [@base_url]
  end

  def crawl
    @crawl_queue.each do |url|
      crawl_url(url)
    end

    @sitemap.to_json
  end

  private

  def crawl_url(url)
    page   = Nokogiri::HTML(open(url, allow_redirections: :all))

    links  = clear_elements(page.css('a[href]'), 'href')
    assets = clear_elements(page.css('[src]'), 'src')

    check_new_discoveries(links)

    @sitemap << { url: url, links: links, assets: assets }
  end

  def build_base_url
    fail 'url needs to be valid' unless @uri.kind_of?(URI::Generic)

    scheme = @uri.scheme || 'http'
    host   = @uri.host.downcase

    "#{scheme}://#{host}"
  end

  def check_new_discoveries(links)
    links.each do |link|
      @crawl_queue << link unless @crawl_queue.include?(link)
    end
  end

  def clear_elements(elements, attribute)
    elements.map do |asset|
      value = asset.attributes["#{attribute}"].value
      if value.start_with?('/') && !value.start_with?('//')
        "#{@base_url}#{value}"
      elsif value.start_with?(@base_url)
        value
      end
    end.compact
  end
end
