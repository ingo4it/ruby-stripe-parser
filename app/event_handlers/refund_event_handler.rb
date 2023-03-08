
class RefundEventHandler < EventHandler
  def initialize(event)
    @event = event
    @data = @event.data.object
  end

  def created
    StripeData::Refund.create!(record_fields)
  rescue ActiveRecord::RecordNotUnique
    update!
  end

  alias_method :create!, :created

  def updated
    StripeData::Refund.find_by!(stripe_id: @data.id).update!(record_fields)
  rescue ActiveRecord::RecordNotFound
    create!
  end

  alias_method :update!, :updated

  private

  def record_fields
    {
      stripe_id: @data.id,
      object: @data.object,
      amount: @data.amount,
      balance_transaction: @data.balance_transaction,
      charge: @data.charge,
      stripe_created: DateTime.strptime(@data.created.to_s, '%s'),
      currency: @data.currency,
      metadata: @data.metadata,
      reason: @data.reason,
      receipt_number: @data.receipt_number,
      status: @data.status
    }
  end
end
