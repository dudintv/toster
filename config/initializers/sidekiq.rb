Sidekiq.configure_server do |config|
  config.average_scheduled_poll_interval = 5
end

schedule_file = 'config/schedule.yml'

Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if File.exist?(schedule_file) && Sidekiq.server?

Sidekiq.options[:poll_interval] = 10
