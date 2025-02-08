# Creating the Sidekiq Worker `gem 'sidekiq-cron'`

In Sidekiq, background jobs are executed by workers. We’ll create a worker called PostFetcherWorker to fetch posts from an external API and update the local database with the retrieved data.

# Configuring Sidekiq Scheduler

We need to configure Sidekiq to schedule the PostFetcherWorker to run at regular intervals.

# Adding Sidekiq Routes

To monitor and manage Sidekiq jobs, we need to add the Sidekiq web interface to our application’s routes. With this configuration, the Sidekiq web interface will be accessible at http://localhost:3000/sidekiq. Additionally, we have defined a route for the posts#index action, which you can customize based on your application's requirements.

# Running Sidekiq

`bundle exec sidekiq`

# Coding

`gem 'sidekiq-cron'`

#### app/workers/post_fetcher_worker.rb

```ruby
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
```

#### config/initializers/sidekiq_cron.rb

```ruby
require 'sidekiq-cron'

Sidekiq::Cron::Job.create(
  name: 'Update posts every 30 seconds',
  cron: '*/30 * * * * *', # Runs every 30 seconds
  class: 'PostFetcherWorker',
  args: []
)
```

#### config/routes.rb

```ruby
require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
end
```

`bundle exec sidekiq` => http://localhost:3000/sidekiq

---

- Create model teams
- Create buy_time_worker
- Create teams_controller and call buy_time_worker
- Create fake teams by seeds.rb

Go to start sidekiq => http://localhost:3000/api/v1/teams/:id to check
