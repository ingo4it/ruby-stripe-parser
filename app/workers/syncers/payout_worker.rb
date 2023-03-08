
module Syncers
  class PayoutWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'backfill'

    def perform(starting_after, page_size, page)
      stripe_data = Stripe::Payout.list(
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
        PayoutScheduler.call(stripe_data.data.last.id, page_size, page + 1)
      end
    end

    private

    def save(stripe_data)
      stripe_data.each do |payout|
        initialized_record = StripeData::Payout.find_or_initialize_by(stripe_id: payout.id)

        initialized_record.update!(
          stripe_id: payout.id,
          object: payout.object,
          amount: payout.amount,
          arrival_date: Time.at(payout.arrival_date.to_i),
          balance_transaction: payout.balance_transaction,
          stripe_created: DateTime.strptime(payout.created.to_s, '%s'),
          currency: payout.currency,
          description: payout.description,
          destination: payout.destination,
          failure_balance_transaction: payout.failure_balance_transaction,
          failure_code: payout.failure_code,
          failure_message: payout.failure_message,
          livemode: payout.livemode,
          metadata: payout.metadata,
          method: payout.method,
          source_type: payout.source_type,
          statement_descriptor: payout.statement_descriptor,
          status: payout.status,
          stripe_type: payout.type
        )

        BalanceTransactionScheduler.call(initialized_record.id, payout.id)
      end
    end

    def logger
      ActiveSupport::TaggedLogging.new(Logger.new("log/#{self.class.to_s.demodulize.underscore}.log"))
    end
  end
end
