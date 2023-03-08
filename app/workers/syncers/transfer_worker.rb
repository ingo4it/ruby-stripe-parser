
module Syncers
  class TransferWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'backfill'

    def perform(starting_after, page_size, page)
      stripe_data = Stripe::Transfer.list(
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
        TransferScheduler.call(stripe_data.data.last.id, page_size, page + 1)
      end
    end

    private

    def save(stripe_data)
      stripe_data.each do |transfer|
        initialized_record = StripeData::Transfer.find_or_initialize_by(stripe_id: transfer.id)

        initialized_record.update!(
          stripe_id: transfer.id,
          object: transfer.object,
          amount: transfer.amount,
          amount_reversed: transfer.amount_reversed,
          balance_transaction: transfer.balance_transaction,
          stripe_created: DateTime.strptime(transfer.created.to_s, '%s'),
          currency: transfer.currency,
          description: transfer.description,
          destination: transfer.destination,
          livemode: transfer.livemode,
          metadata: transfer.metadata,
          reversals: transfer.reversals,
          reversed: transfer.reversed,
          source_transaction: transfer.source_transaction,
          source_type: transfer.source_type,
          transfer_group: transfer.transfer_group
        )
      end
    end

    def logger
      ActiveSupport::TaggedLogging.new(Logger.new("log/#{self.class.to_s.demodulize.underscore}.log"))
    end
  end
end
