
module Syncers
  class CustomerWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'backfill'

    def perform(starting_after, page_size, page)
      stripe_data = Stripe::Customer.list(
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
        CustomerScheduler.call(stripe_data.data.last.id, page_size, page + 1)
      end
    end

    private

    def save(stripe_data)
      stripe_data.each do |customer|
        initialized_record = StripeData::Customer.find_or_initialize_by(stripe_id: customer.id)

        initialized_record.update!(
          stripe_id: customer.id,
          account_balance: customer.account_balance,
          currency: customer.currency,
          stripe_created: DateTime.strptime(customer.created.to_s, '%s'),
          default_source: customer.default_source,
          delinquent: customer.delinquent,
          # description: customer.description,
          discount: customer.discount.to_json,
          livemode: customer.livemode,
          metadata: customer.metadata.to_json,
          shipping: customer.shipping.to_json
        )
      end
    end

    def logger
      ActiveSupport::TaggedLogging.new(Logger.new("log/#{self.class.to_s.demodulize.underscore}.log"))
    end
  end
end
