
module Syncers
  class DisputeWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'backfill'

    def perform(starting_after, page_size, page)
      stripe_data = Stripe::Dispute.list(
        limit: page_size,
        starting_after: starting_after,
        include: %w(total_count)
      )

      logger.info(
        "page #{page} of #{(stripe_data.total_count.to_f / page_size).ceil}, " \
        "starting_after: #{starting_after}"
      )

      save(stripe_data.data)

      if stripe_data.has_more
        DisputeScheduler.call(stripe_data.data.last.id, page_size, page + 1)
      end
    end

    private

    def save(stripe_data)
      stripe_data.each do |dispute|
        initialized_record = StripeData::Dispute.find_or_initialize_by(stripe_id: dispute.id)

        initialized_record.update!(
          stripe_id: dispute.id,
          object: dispute.object,
          amount: dispute.amount,
          balance_transactions: dispute.balance_transactions,
          charge: dispute.charge,
          stripe_created: DateTime.strptime(dispute.created.to_s, '%s'),
          currency: dispute.currency,
          evidence: dispute.evidence,
          evidence_details: dispute.evidence_details,
          is_charge_refundable: dispute.is_charge_refundable,
          livemode: dispute.livemode,
          metadata: dispute.metadata,
          reason: dispute.reason,
          status: dispute.status
        )
      end
    end

    def logger
      ActiveSupport::TaggedLogging.new(Logger.new("log/#{self.class.to_s.demodulize.underscore}.log"))
    end
  end
end
