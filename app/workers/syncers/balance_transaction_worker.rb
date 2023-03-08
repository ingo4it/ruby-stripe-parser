
module Syncers
  class BalanceTransactionWorker
    include Sidekiq::Worker

    def perform(payout_id, stripe_payout_id, starting_after, page_size, page)
      stripe_data = Stripe::BalanceTransaction.list(
        limit: page_size,
        starting_after: starting_after,
        include: %w(total_count),
        payout: stripe_payout_id
      )

      logger.info(
        "page #{page} of #{(stripe_data.total_count.to_f / page_size).ceil}, " \
        "starting_after: #{starting_after}"
      )

      save(stripe_data.data, payout_id)

      BalanceTransactionScheduler.call(
        payout_id, stripe_payout_id, stripe_data.data.last.id, page_size, page + 1
      ) if stripe_data.has_more
    rescue Stripe::InvalidRequestError => e
      raise e unless e.message == 'Balance transaction history can only be filtered on automatic transfers, not manual.'
    end

    private

    def save(stripe_data, payout_id)
      stripe_data.each do |bt|
        initialized_record = StripeData::BalanceTransaction.find_or_initialize_by(stripe_id: bt.id)

        initialized_record.update!(
          stripe_id: bt.id,
          payout_id: payout_id,
          object: bt.object,
          amount: bt.amount,
          available_on: Time.at(bt.available_on.to_i),
          stripe_created: DateTime.strptime(bt.created.to_s, '%s'),
          currency: bt.currency,
          description: bt.description,
          fee: bt.fee,
          net: bt.net,
          source: bt.source,
          status: bt.status,
          stripe_type: bt.type
        )

        StripeData::FeeDetail.where(balance_transaction_id: bt.id).delete_all

        bt.fee_details.each do |fee_detail|
          StripeData::FeeDetail.create!(
            balance_transaction_id: initialized_record.id,
            amount: fee_detail[:amount],
            application: fee_detail[:application],
            currency: fee_detail[:currency],
            description: fee_detail[:description],
            stripe_type: fee_detail[:type]
          )
        end
      end
    end

    def logger
      ActiveSupport::TaggedLogging.new(Logger.new("log/#{self.class.to_s.demodulize.underscore}.log"))
    end
  end
end
