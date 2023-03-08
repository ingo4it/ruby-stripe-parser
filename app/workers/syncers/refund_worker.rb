
module Syncers
  class RefundWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'backfill'

    def perform(starting_after, page_size, page)
      stripe_data = Stripe::Refund.list(
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
        RefundScheduler.call(stripe_data.data.last.id, page_size, page + 1)
      end
    end

    private

    def save(stripe_data)
      stripe_data.each do |refund|
        initialized_record = StripeData::Refund.find_or_initialize_by(stripe_id: refund.id)

        initialized_record.update!(
          stripe_id: refund.id,
          object: refund.object,
          amount: refund.amount,
          balance_transaction: refund.balance_transaction,
          charge: refund.charge,
          stripe_created: DateTime.strptime(refund.created.to_s, '%s'),
          currency: refund.currency,
          metadata: refund.metadata,
          reason: refund.reason,
          receipt_number: refund.receipt_number,
          status: refund.status
        )
      end
    end

    def logger
      ActiveSupport::TaggedLogging.new(Logger.new("log/#{self.class.to_s.demodulize.underscore}.log"))
    end
  end
end
