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
    context 'when an empty value is passed' do
      it 'raises an error' do
        expect { NiceCrawler.new('') }.to raise_error
      end
    end

    context 'when url is clean' do
      it 'returns a new instance' do
        expect(NiceCrawler.new(url)).to be_instance_of(NiceCrawler)
      end

      it 'returns the base url' do
        expect(NiceCrawler.new(url).base_url).to eq(url)
      end
    end

    context 'when url is dirty' do

      let(:dirty_url) { url + '/something?dirty=true' }

      it 'returns a new instance' do
        expect(NiceCrawler.new(dirty_url)).to be_instance_of(NiceCrawler)
      end

      it 'returns the base url' do
        expect(NiceCrawler.new(dirty_url).base_url).to eq(url)
      end
    end

    context 'when url is only a domain' do
      let(:domain) { 'example.com' }

      it 'raises an error' do
        expect { NiceCrawler.new(domain) }.to raise_error
      end

    end
  end

  describe '#crawl' do

    let(:crawler) { NiceCrawler.new(url) }
    let(:result)  { File.open(File.expand_path('../../support/sitemap.json', __FILE__)) }

    it 'returns a json' do
      expect(crawler.crawl).to eq(result.read.strip)
    end

  end

end
