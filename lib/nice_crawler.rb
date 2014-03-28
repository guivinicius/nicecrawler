require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

class NiceCrawler
  def initialize(url)
    fail 'url is required' if url.empty?

    @base_url    = build_base_url(url)

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
    page = Nokogiri::HTML(open(url, allow_redirections: :all))

    links = page.css('a').map do |link|
      value = link.attributes['href'].value
      if value.start_with?('/')
        "#{@base_url}#{value}"
      elsif value.start_with?(@base_url)
        value
      end
    end

    assets = page.css('[src]').map do |asset|
      value = asset.attributes['src'].value
      if value.start_with?('/') && !value.start_with?('//')
        "#{@base_url}#{value}"
      elsif value.start_with?(@base_url)
        value
      end
    end

    check_new_discoveries(links)

    @sitemap << { url: url, links: links, assets: assets }
  end

  def build_base_url(url)
    scheme = URI.parse(url).scheme || 'http'
    host   = URI.parse(url).host.downcase

    "#{scheme}://#{host}"
  end

  def check_new_discoveries(links)
    links.each do |link|
      @crawl_queue << link unless @crawl_queue.include?(link)
    end
  end
end
