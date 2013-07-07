require 'rubygems'
require 'oauth'
require 'json'

# keys removed after a friend helpfully pointed out the obvious security risks
consumer_key = OAuth::Consumer.new(
  "",
  "")
access_token = OAuth::Token.new(
  "",
  "")

# Note that the type of request has changed to POST.
# The request parameters have also moved to the body
# of the request instead of being put in the URL.
baseurl = "https://api.twitter.com"
path    = "/1.1/statuses/update.json"
address = URI("#{baseurl}#{path}")
request = Net::HTTP::Post.new address.request_uri
request.set_form_data(
  "status" => "If this tweet works, I'll have successfully interfaced with the Twitter API from Ruby... only now from my own server!",
)

# Set up HTTP.
http             = Net::HTTP.new address.host, address.port
http.use_ssl     = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

# Issue the request.
request.oauth! http, consumer_key, access_token
http.start
response = http.request request

# Parse and print the Tweet if the response code was 200
tweet = nil
if response.code == '200' then
  tweet = JSON.parse(response.body)
  puts "Successfully sent #{tweet["text"]}"
else
  puts "Could not send the Tweet! " +
    "Code:#{response.code} Body:#{response.body}"
end
