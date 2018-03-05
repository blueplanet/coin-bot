class ApplicationJob < ActiveJob::Base

  private

    def default_url_options
      { host: ENV['HOST_NAME'] }
    end
end
