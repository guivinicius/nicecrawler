class PageMock
  SPEC_DOMAIN = 'http://example.com'

  def initialize(name, options = {})
    @name   = name
    @links  = options[:links].flatten  if options.key?(:links)
    @hrefs  = options[:hrefs].flatten  if options.key?(:hrefs)
    @assets = options[:assets].flatten if options.key?(:assets)

    prepare_webmock
  end

  def url
    SPEC_DOMAIN + @name
  end

  private

  def prepare_webmock
    options = { body: body_builder, content_type: 'text/html', status: 200 }
    WebMock.stub_request(:get, url).to_return(options)
  end

  def body_builder
    html_links  = @links.map { |l| "<a href=\"#{SPEC_DOMAIN}#{l}\"></a>" }.join if @links
    html_hrefs  = @hrefs.map { |h| "<a href=\"/#{h}\"></a>" }.join if @hrefs
    html_assets = @assets.map { |a| "<img src=\"/assets/#{a}\"></a>" }.join if @assets

    "<body>#{html_links}#{html_hrefs}#{html_assets}</body>"
  end
end
