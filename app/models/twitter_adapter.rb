# Use this or gem from https://github.com/sferik/twitter

module TwitterAdapter

  def self.search(search_string)
  
    bearer_token = generate_bearer_token
    search_string.gsub(/\s+/, "%20")

    url = URI("https://api.twitter.com/1.1/search/tweets.json?q=%2523#{search_string}&result_type=recent")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["authorization"] = "Bearer #{bearer_token}"

    response = JSON.parse(http.request(request).read_body)["statuses"]
                   .map { |result| result["text"] }

  end

private 

  def self.generate_bearer_token

    url = URI("https://api.twitter.com/oauth2/token")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    consumer_key    = ENV['TWITTER_CONSUMER_KEY']
    consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    bearer_token_credentials = Base64.strict_encode64("#{consumer_key}:#{consumer_secret}")

    request = Net::HTTP::Post.new(url)
    request["authorization"] = "Basic #{bearer_token_credentials}"
    request["content-type"] = 'application/x-www-form-urlencoded;charset=UTF-8'
    request.body = "grant_type=client_credentials"

    response = JSON.parse http.request(request).read_body
    response["access_token"]

  end
end