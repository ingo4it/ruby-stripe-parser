
module Syncers
  class EventWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'backfill'

    def perform(starting_after, page_size, page)
      stripe_data = Stripe::Event.list(
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
        EventScheduler.call(stripe_data.data.last.id, page_size, page + 1)
      end
    end

    private

    def save(stripe_data)
      stripe_data.each do |event|
        initialized_record = StripeData::Event.find_or_initialize_by(stripe_id: event.id)

        initialized_record.update!(
          stripe_id: event.id,
          object: event.object,
          api_version: event.api_version,
          stripe_created: DateTime.strptime(event.created.to_s, '%s'),
          data: event.data,
          livemode: event.livemode,
          pending_webhooks: event.pending_webhooks,
          request: event.request,
          stripe_type: event.type
        )
      end
    end

    def logger
      ActiveSupport::TaggedLogging.new(Logger.new("log/#{self.class.to_s.demodulize.underscore}.log"))
    end
  end
end
