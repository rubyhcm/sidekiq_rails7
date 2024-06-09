require 'net/http'

class PostFetcherWorker
  include Sidekiq::Worker

  API_ENDPOINT = 'https://jsonplaceholder.typicode.com/posts'

  def perform
    begin
      uri = URI(API_ENDPOINT)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.path)

      response = http.request(request)

      raise "Failed to fetch posts: #{response.body}" unless response.code == '200'

      posts = JSON.parse(response.body)
      process_posts(posts)
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  private

  def process_posts(posts)
    posts.each do |post|
      process_post(post)
    end
  end

  def process_post(post)
    id = post['id']
    title = post['title']
    body = post['body']

    existing_post = Post.find_by(id: id)

    if existing_post
      puts "Skipping existing post with ID #{id}"
    else
      Post.create(title: title, body: body)
    end
  end
end
