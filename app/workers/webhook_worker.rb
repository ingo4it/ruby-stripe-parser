class WebhookWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'webhook'

  def perform(class_name, method_name, payload)
    class_name.constantize.new(
      Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    ).send(method_name)
  end
end
