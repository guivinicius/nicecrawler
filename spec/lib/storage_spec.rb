require 'spec_helper'

describe Storage do

  let(:storage) { Storage.new('digitalocean.com') }
  let(:hash) do
    hash = {
      url: 'http://digitalocean.com',
      sites: ['http://digitalocean.com/about'],
      assets: []
    }
  end

  it 'returns a new storage' do
    expect(storage).to be_kind_of(Storage)
  end

  it 'appends a hash to storage' do
    expect(storage.append(hash)).to be_true
  end

  it 'shows a sitemap' do
    storage.append(hash)
    expect(storage.sitemap.to_json).to eq([hash].to_json)
  end
end
