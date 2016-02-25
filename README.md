# astro-gibberish twitter bot

## About

I made this primarily for my own entertainment, inspired by things like [shitty.news](http://shitty.news) and [subreddit simulator](https://www.reddit.com/r/SubredditSimulator/). It pulls some tid-bits about astronomy, technology, and other nerdy things from a few APIs including:

  * astrocast -- a collection of astronomy facts
  * wired.com -- technology news
  * fortrabbits quotes -- a json file of quotes on github

## To build 
To use the astronomy gibberish script and get some entertaining markov-chain generated sentences:

```
git clone https://github.com/astro-gibberish/astro-gibberish-twitter-bot.git
cd astro-gibberish-twitter-bot
gem install bundler
bundle install
./astro gibberish
```

### More about the astronomy Facts Script

This simple ruby script gives astronomy facts.

Move to /usr/local/bin to call `astro` as a command!

Arguments available:
  - Basic example: `astro pretty` gives output in text/paragraph output
  - Tag example: `astro sun moon` will use 'sun' and 'moon' as tags to search the api.
  - Since pretty is an argument, `astro pretty sun moon` will work as well.

Basic use:
```
$ astro
{"name"=>"If we stood on the moon we would see stars during the day because the moon has no atmosphere", "tags"=>["moon", "star", "fact", "atmosphere"], "_id"=>"5239ad8606dc90bc0200000a"}
```

Use with pretty and tags:
```
$ astro pretty star helium
All chemical elements, except for mainly Hydrogen and Helium, were produced inside stars

Tags: star, fact, hydrogen, helium
```

