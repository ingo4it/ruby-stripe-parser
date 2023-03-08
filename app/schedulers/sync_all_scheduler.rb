
module SyncAllScheduler
  def self.call
    ChargeScheduler.call
    CustomerScheduler.call
    DisputeScheduler.call
    EventScheduler.call
    PayoutScheduler.call
    RefundScheduler.call
    TransferScheduler.call
  end
end
