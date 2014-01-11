require 'concerns/base_workers_methods'

class EventNotificationWorker

  include BaseWorkersMethods

  def perform
    Rails.logger.info "[EventNotificationWorker] It Works."
  end

end
