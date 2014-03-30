class Storage
  include Mongo

  def initialize(domain, opts = {})
    default_opts = {
      address: 'localhost',
      port: 27017,
      database: 'nicecrawler'
    }.merge!(opts)

    address     = default_opts[:address]
    port        = default_opts[:port]
    database    = default_opts[:database]

    @client     = MongoClient.new(address, port).db(database)
    @collection = @client.create_collection('sitemaps')
    @collection.create_index('domain')
    @id         = @collection.insert('domain' => domain, 'sitemap' => [])
  end

  def append(hash)
    @collection.update({ '_id' => @id }, { '$push' => { 'sitemap' => hash } })
  end

  def sitemap
    @collection.find_one('_id' => @id)['sitemap']
  end
end
