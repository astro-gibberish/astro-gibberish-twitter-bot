require './astro'



RSpec.describe bite = rand_bite('sun') do
  context "getting bites by tag" do
    it "returns an astronomy bite related to the tag" do
      expect(bite['tags'].include?('sun')).to eq true
    end
  end
end

RSpec.describe rand_bite('') do
  context "getting bites with no tags" do
    it "returns a random bite from the whole list" do
      expect(bite['name'].class).to eq String
    end
  end
end


RSpec.describe get_raw_text do
  context "types are as expected" do
    it "returns an array of text for marky markov to parse" do
      samples = []
      samples += get_raw_text(count: 10)
      expect(samples.class).to eq Array
      expect(samples[0].class).to eq Hash
      expect(samples[0]['text'].class).to eq String
    end
  end
end


