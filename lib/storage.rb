class Storage
  include Mongo

  attr_reader :id

  def initialize(domain, opts = {})
    default_opts = {
      address: 'localhost',
      port: 27017,
      database: 'nicecrawler'
    }.merge!(opts)

    address  = default_opts[:address]
    port     = default_opts[:port]
    database = default_opts[:database]

    @client = MongoClient.new(address, port).db(database)

    @collection = create_collection
    @collection.create_index('domain')

    @id = create_document(domain)
  end

  def append(hash)
    @collection.update({ '_id' => @id }, { '$push' => { 'sitemap' => hash } })
  end

  def sitemap
    @collection.find('_id' => @id).first['sitemap']
  end

  private

  def create_collection
    @client.create_collection('sitemaps')
  end

  def create_document(domain)
    @collection.insert('domain' => domain, 'sitemap' => [])
  end
end
