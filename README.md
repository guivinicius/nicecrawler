# NiceCrawler

A simple and nice web crawler.

It uses MongoDB to store the sitemap, so you need it to run the script.

http://docs.mongodb.org/manual/installation/

## Command-line

```bash
  cd YOUR_PATH/nicecrawler
  bundle install
  start your mongodb ...

  ./bin/nicecrawler http://digitalocean.com > sitemap.json
```

## Ruby

```ruby
  require 'nice_crawler'

  url = 'http://digitalocean.com'

  crawler = NiceCrawler.new(url)
  crawler.crawl
  puts crawler.sitemap
```

## MongoDB Options

By default it points to **localhost:27017**, but it can be changed passing
additional parameters to the class.

```ruby
  opts = {
    address: 111.222.11.22,
    port: 1122,
    database: 'myownname'
  }

  url = 'http://guivinicius.com'
  NiceCrawler.new(url, opts).crawl
```
