# NiceCrawler

A simple and nice web crawler.

## Browser

It's Sinatra so it's easy.

```bash
  cd YOUR_PATH/nicecrawler
  bundle install
  sinatra app.rb
```

Then go to http://localhost:3000, input a domain into the text field and
receive your site map.


## Command line

```bash
  cd YOUR_PATH/nicecrawler
  bundle install
  ./bin/nicecrawler http://digitalocean.com > sitemap.json
```

## Ruby scripting

```ruby
  require 'nice_crawler'

  url = 'http://digitalocean.com'

  crawler = NiceCrawler.new(url)
  crawler.crawl
  # or
  crawler.be_nice_and_crawl
```
