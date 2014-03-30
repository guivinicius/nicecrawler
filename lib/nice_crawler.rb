require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'json'

require 'mongo'
require 'storage'

class NiceCrawler
  attr_reader :base_url

  def initialize(url = '', storage_opts = {})
    fail 'url is required' if url.empty?

    @uri         = URI.parse(url)
    @base_url    = build_base_url
    @crawl_queue = [@base_url]

    @storage     = Storage.new(@base_url, storage_opts)
  end

  def crawl
    @crawl_queue.each do |url|
      begin
        @storage.append(crawl_url(url))
      rescue => e
        puts e
      end
    end
  end

  def sitemap
    @storage.sitemap
  end

  private

  def crawl_url(url)
    page   = Nokogiri::HTML(open(url, allow_redirections: :all))

    links  = clear_elements(page.css('a[href]'), 'href')
    assets = clear_elements(page.css('[src]'), 'src')

    check_new_discoveries(links)

    { url: url, links: links, assets: assets }
  end

  def build_base_url
    fail 'url needs to be valid' if @uri.instance_of?(URI::Generic)

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
    elements.map do |e|
      value = e.attributes["#{attribute}"].value
      if value.start_with?('/') && !value.start_with?('//')
        "#{@base_url}#{value}"
      elsif value.start_with?(@base_url)
        value
      end
    end.compact
  end
end
