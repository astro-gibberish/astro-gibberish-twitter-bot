#!/usr/bin/env ruby
# This is a script that simply gets a random bit of information about astronomy
# There are a few args you can pass from cmd line:
#   - "pretty" > if you use pretty, you'll get text. By default you'll get the json
#   - Any other args you pass in will be used as a tag.
#     - Multiple tags are an "AND" search, not "OR".
# Unirest is used for http requests: http://unirest.io/ruby.html
# Astrocast is used for the information: http://astrocast.org/index.php
require 'unirest'
require 'marky_markov'
require 'xmlsimple'

@pretty = true if ARGV.include? 'pretty' || @pretty = false
@tags = (ARGV.delete_if{|i|i=='pretty'}).join(",")
@gibberish = true if ARGV.include? 'gibberish' || @gibberish = false
@verbose = true if ARGV.include? '-v' || @verbose = false

def gibberish(dict_depth: 2, num_sentences: 2)
  text = ""
  bites = n_bites()
  samples = pad_markov_chain()
  bites.each do |b|
    text += b["name"] + '. '
  end
  samples.each do |q|
    text += q["text"] + '. '
  end
  abort("No source text found") if samples.empty?
  markov = MarkyMarkov::TemporaryDictionary.new(dict_depth)
  markov.parse_string(text)
  return  markov.generate_n_sentences num_sentences 
end

def pad_markov_chain()
  # Some sentences to pad the markov chain dictionary with
  samples = [] 
  samples += get_raw_text()
 # samples += get_wired()
  samples += get_fortrabbit_quotes()
  return samples
end

def get_raw_text(count: nil)
  raw_text = []
  filepath = '/etc/astro-bot/extra_text/*.txt'
  puts "Getting extra text from disk" if @verbose
  Dir.glob(filepath) do |file|
    open(file, 'r').readlines.each do |line|
      raw_text.push({"text" => line})
    end
  end
  unless count then
    return raw_text
  else
    puts raw_text.sample(count).length if @verbose
    return raw_text.sample(count) 
  end
end

def get_fortrabbit_quotes()
  quotes_url = "https://raw.githubusercontent.com/fortrabbit/quotes/master/quotes.json"
  puts "Getting quotes from #{quotes_url}" if @verbose
  q = Unirest.get(quotes_url).body
  samples = q if q.class == Array
  samples = [q] if q.class == String
  return samples
end

def get_wired()
  samples = []
  wired_categories = ["gear", "science", "business", "design", "underwire", 
                      "reviews", "science-blogs", "threatlevel", "culture", 
                      "transportation"]
  wired_categories.each do |cat|
    XmlSimple.xml_in(
      Unirest.get( "http://www.wired.com/category/#{cat}/feed/").body.force_encoding('UTF-8')
    )["channel"][0]["item"].each do |item|
      item["title"].each do |title|
        samples.push({"text" => title})
      end
    end
  end
  return samples
end

def rand_bite(tags)
  tags_query = "?tags=#{tags}" unless tags == nil
  bite = Unirest.get("http://astrocast.herokuapp.com/bites#{tags_query}").body
  return bite[rand(bite.length)] || {"name" => "No matching objects found!", 
                                     "tags" => tags.split(',')}
end

def n_bites()
  astrocast = "http://astrocast.herokuapp.com/bites"
  puts "Getting bites from #{astrocast}" if @verbose
  bites = Unirest.get(astrocast).body
  return bites
end

if __FILE__ == $0 then
  unless defined?(@gibberish) then
    if defined?(@pretty)
      text = rand_bite(@tags)
      puts "#{text['name']}\n\nTags: #{text['tags'].join(', ')}" 
    else
      puts rand_bite(@tags)
    end
  else
    puts gibberish(dict_depth: 2, num_sentences: 3) + "\n\n"
  end
end
