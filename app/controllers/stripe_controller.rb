
class StripeController < ApplicationController
  def webhook
    payload = request.raw_post

    begin
      payload_json = JSON.parse(payload, symbolize_names: true)
      klass, *method_array = payload_json[:type].split('.')
      sig_header = request.headers['HTTP_STRIPE_SIGNATURE']
      endpoint_secret = Rails.configuration.stripe[:webhook_secret]

      # debug
      # Stripe::Webhook::Signature.verify_header(
      #   payload, sig_header, endpoint_secret, tolerance: Stripe::Webhook::DEFAULT_TOLERANCE
      # )

    rescue JSON::ParserError => e
      # Invalid payload      
      head 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      head 400
      return
    end

    class_name = "#{klass.capitalize}EventHandler"
    method_name = method_array.join('_').to_sym
    class_name.constantize.new(
      Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    ).send(method_name)

    head 200
  rescue NameError
    # unwatched webhook received
  end
end
