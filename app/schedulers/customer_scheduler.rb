
class CustomerScheduler
  def self.call(starting_after = nil, page_size = 100, page = 1)
    Syncers::CustomerWorker.perform_async(starting_after, page_size, page)
  end
end
