
class DisputeEventHandler < EventHandler
  def initialize(event)
    @event = event
    @data = @event.data.object
  end

  def created
    StripeData::Dispute.create!(record_fields)
  rescue ActiveRecord::RecordNotUnique
    update!
  end

  alias_method :create!, :created

  def updated
    StripeData::Dispute.find_by!(stripe_id: @data.id).update!(record_fields)
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
      balance_transactions: @data.balance_transactions,
      charge: @data.charge,
      stripe_created: DateTime.strptime(@data.created.to_s, '%s'),
      currency: @data.currency,
      evidence: @data.evidence,
      evidence_details: @data.evidence_details,
      is_charge_refundable: @data.is_charge_refundable,
      livemode: @data.livemode,
      metadata: @data.metadata,
      reason: @data.reason,
      status: @data.status
    }
  end
end
