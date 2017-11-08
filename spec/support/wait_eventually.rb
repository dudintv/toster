module WaitEventually
  def eventually(timeout: Capybara.default_max_wait_time, interval: 0.01)
    Timeout.timeout(timeout) do
      begin
        yield
      rescue Capybara::ElementNotFound, Capybara::ExpectationNotMet, RSpec::Expectations::ExpectationNotMetError
        sleep interval
        puts "+ TICK #{interval}"
        retry
      end
    end
  rescue Timeout::Error
    yield
  end
end

RSpec.configure do |config|
  config.include WaitEventually, type: :feature
end
