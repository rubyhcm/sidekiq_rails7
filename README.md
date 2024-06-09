# Creating the Sidekiq Worker `gem 'sidekiq-cron'`

In Sidekiq, background jobs are executed by workers. We’ll create a worker called PostFetcherWorker to fetch posts from an external API and update the local database with the retrieved data.

# Configuring Sidekiq Scheduler

We need to configure Sidekiq to schedule the PostFetcherWorker to run at regular intervals.
