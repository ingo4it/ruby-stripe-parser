
class ChargeEventHandler < EventHandler
  def initialize(event)
    @event = event
    @data = @event.data.object
  end

  def succeeded
    update!
  end

  def updated
    update!
  end

  def dispute_created
    DisputeEventHandler.new(@event).created
  end

  def dispute_updated
    DisputeEventHandler.new(@event).updated
  end

  def refund_updated
    RefundEventHandler.new(@event).updated
  end

  private

  def update!
    record = StripeData::Charge.find_by!(stripe_id: @data.id)
    record.update!(record_fields)
    update_metadata!(record)
  rescue ActiveRecord::RecordNotFound
    create!
  end

  def create!
    record = StripeData::Charge.create!(record_fields)
    update_metadata!(record)
  rescue ActiveRecord::RecordNotUnique
    update!
  end

  def update_metadata!(charge)
    return if @data.metadata.to_hash.empty?

    StripeData::ChargeMetadata
      .find_or_initialize_by(stripe_charge_id: charge.id)
      .update!(data: @data.metadata.to_hash.except('email'))
  end

  def record_fields
    {
      stripe_id: @data.id,
      object: @data.object,
      amount: @data.amount,
      amount_refunded: @data.amount_refunded,
      application: @data.application,
      application_fee: @data.application_fee,
      balance_transaction: @data.balance_transaction,
      captured: @data.captured,
      stripe_created: DateTime.strptime(@data.created.to_s, '%s'),
      currency: @data.currency,
      customer: @data.customer,
      description: @data.description,
      destination: @data.destination,
      dispute: @data.dispute.try(&:id),
      failure_code: @data.failure_code,
      failure_message: @data.failure_message,
      fraud_details: @data.fraud_details,
      invoice: @data.invoice,
      livemode: @data.livemode,
      on_behalf_of: @data.on_behalf_of,
      order: @data.order,
      outcome: @data.outcome,
      paid: @data.paid,
      receipt_number: @data.receipt_number,
      refunded: @data.refunded,
      review: @data.review,
      shipping: @data.shipping,
      source: @data.source,
      source_transfer: @data.source_transfer,
      statement_descriptor: @data.statement_descriptor,
      status: @data.status,
      transfer_group: @data.transfer_group
    }
  end
end
