require 'heroku-api'
require 'newrelic_api'

class NewRelicWrapper
  def initialize(app_id)
    NewRelicApi.api_key = ENV['NEW_RELIC_API_KEY']
    @app_id = app_id
  end

  def throughput
    application.threshold_values.detect { |a| a.name == 'Throughput' }.metric_value
  end

  def application
    account.applications.detect { |a| a.id = @app_id.to_s }
  end

  def account
    NewRelicApi::Account.find(:first)
  end
end

def number_of_workers
  new_relic = NewRelicWrapper.new(1898958) # data2.sv.app
  rpm = new_relic.throughput
  workers = (rpm / 1400.0).ceil
rescue
  3
end

namespace :scheduler do
  desc "Shift and create logs"
  task :scale_dynos => :environment do
    workers = number_of_workers

    heroku = Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
    heroku.post_ps_scale('sv-stats', :worker , workers)
    heroku.post_ps_scale('sv-data2', :web , workers)
  end
end
