require 'spec_helper'

describe NiceCrawler do

  let(:url) { 'https://digitalocean.com' }

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

  end

end
