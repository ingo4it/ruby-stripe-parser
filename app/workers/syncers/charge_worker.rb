
module Syncers
  class ChargeWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'backfill'

    def perform(starting_after, page_size, page)
      stripe_data = Stripe::Charge.list(
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
        ChargeScheduler.call(stripe_data.data.last.id, page_size, page + 1)
      end
    end

    private

    def save(stripe_data)
      stripe_data.each do |charge|
        initialized_record = StripeData::Charge.find_or_initialize_by(stripe_id: charge.id)

        initialized_record.update!(
          object: charge.object,
          amount: charge.amount,
          amount_refunded: charge.amount_refunded,
          application: charge.application,
          application_fee: charge.application_fee,
          balance_transaction: charge.balance_transaction,
          captured: charge.captured,
          currency: charge.currency,
          customer: charge.customer,
          description: charge.description,
          destination: charge.destination,
          dispute: charge.dispute.try(&:id),
          failure_code: charge.failure_code,
          failure_message: charge.failure_message,
          fraud_details: charge.fraud_details,
          invoice: charge.invoice,
          livemode: charge.livemode,
          on_behalf_of: charge.on_behalf_of,
          order: charge.order,
          outcome: charge.outcome,
          paid: charge.paid,
          receipt_number: charge.receipt_number,
          refunded: charge.refunded,
          review: charge.review,
          shipping: charge.shipping,
          stripe_created: DateTime.strptime(charge.created.to_s, '%s'),
          source: charge.source,
          source_transfer: charge.source_transfer,
          statement_descriptor: charge.statement_descriptor,
          status: charge.status,
          transfer_group: charge.transfer_group
        )

        metadata_record = initialized_record.charge_metadata
        metadata = charge.metadata.to_h.except(:email)
        if metadata_record
          metadata_record.update(data: metadata)
        else
          initialized_record.build_charge_metadata(data: metadata).save
        end
      end
    end

    def logger
      ActiveSupport::TaggedLogging.new(Logger.new("log/#{self.class.to_s.demodulize.underscore}.log"))
    end
  end
end
