require 'spec_helper'

describe NiceCrawler do

  let(:url) { 'http://example.com' }

  before do
    PageMock.new('', links: ['', '/about'], hrefs: ['help'], assets: ['logo.png'])
    PageMock.new('/about', links: ['','/about','/help'], assets: ['logo.png'])
    PageMock.new('/help', links: ['', '/about', '/help'], hrefs: ['help/article-1','help/article-2'], assets: ['logo.png', 'helper.png'])
    PageMock.new('/help/article-1', links: [''], assets: ['logo.png', 'cover1.png'])
    PageMock.new('/help/article-2', links: [''], assets: ['logo.png', 'cover2.png'])
  end

  describe 'instanciation' do

    it 'returns a new instance' do
      expect(NiceCrawler.new(url)).to be_instance_of(NiceCrawler)
    end

    it 'raises an error' do
      expect { NiceCrawler.new('') }.to raise_error
    end
  end

  describe '#crawl' do

    let(:crawler) { NiceCrawler.new(url) }
    let(:result) { File.open(File.expand_path('../../support/sitemap.json', __FILE__)) }

    it 'returns a json' do
      expect(crawler.crawl).to eq(result.read.strip)
    end

  end

end
