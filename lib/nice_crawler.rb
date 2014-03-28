require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

class NiceCrawler
  def initialize(url)
    fail 'url is required' if url.empty?

    @base_url = url

    @sitemap  = []
    @crawled  = []
  end

  def crawl
    Nokogiri::HTML(open(@base_url, allow_redirections: :all)).css('a[href^="/"]').each do |link|

      value = link.attributes['href'].value

      crawl_url(@base_url + value) unless @crawled.include?(value)
      break
    end

    @sitemap.to_json
  end

  private

  def crawl_url(url)
    page = Nokogiri::HTML(open(url, allow_redirections: :all))

    links = page.css('a[href^="/"]').map { |l| l.attributes['href'].value }
    assets = page.css('[src^="/"]').map { |a| a.attributes['src'].value }

    @sitemap << { url: url, links: links, assets: assets }
    @crawled << url
  end
end
