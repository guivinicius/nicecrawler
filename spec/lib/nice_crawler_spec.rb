require 'spec_helper'

describe NiceCrawler do

  let(:url) { "http://digitalocean.com" }

  it 'returns a new instance' do
    expect(NiceCrawler.new(url)).to be_instance_of(NiceCrawler)
  end

end
