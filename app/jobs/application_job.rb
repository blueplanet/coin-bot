class ApplicationJob < ActiveJob::Base

  protected

    def default_url_options
      { host: ENV['HOST_NAME'] }
    end
end
