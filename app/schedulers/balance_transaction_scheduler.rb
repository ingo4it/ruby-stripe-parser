
class BalanceTransactionScheduler
  def self.call(payout_id, stripe_payout_id, starting_after = nil, page_size = 100, page = 1)
    Syncers::BalanceTransactionWorker.perform_async(payout_id, stripe_payout_id, starting_after, page_size, page)
  end
end
