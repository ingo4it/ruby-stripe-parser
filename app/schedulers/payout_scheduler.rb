
class PayoutScheduler
  def self.call(starting_after = nil, page_size = 100, page = 1)
    Syncers::PayoutWorker.perform_async(starting_after, page_size, page)
  end
end
