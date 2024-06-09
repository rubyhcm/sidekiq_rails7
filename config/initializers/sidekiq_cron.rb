require 'sidekiq-cron'

Sidekiq::Cron::Job.create(
  name: 'Update posts every 30 seconds',
  cron: '*/10 * * * * *', # Runs every 30 seconds
  class: 'PostFetcherWorker',
  args: []
)
