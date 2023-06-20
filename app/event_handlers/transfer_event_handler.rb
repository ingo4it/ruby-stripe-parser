class TransferEventHandler < EventHandler
  def initialize(event)
    @event = event
    @data = @event.data.object
  end

  def created
    StripeData::Transfer.create!(record_fields)
  rescue ActiveRecord::RecordNotUnique
    update!
  end

  alias_method :create!, :created

  def updated
    StripeData::Transfer.find_by!(stripe_id: @data.id).update!(record_fields)
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
      amount_reversed: @data.amount_reversed,
      balance_transaction: @data.balance_transaction,
      stripe_created: DateTime.strptime(@data.created.to_s, '%s'),
      currency: @data.currency,
      description: @data.description,
      destination: @data.destination,
      livemode: @data.livemode,
      metadata: @data.metadata,
      reversals: @data.reversals,
      reversed: @data.reversed,
      source_transaction: @data.source_transaction,
      source_type: @data.source_type,
      transfer_group: @data.transfer_group
    }
  end
end
