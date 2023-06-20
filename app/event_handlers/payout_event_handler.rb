class PayoutEventHandler < EventHandler
  def initialize(event)
    @event = event
    @data = @event.data.object
  end

  def created
    record = StripeData::Payout.create!(record_fields)

    BalanceTransactionScheduler.call(record.id, record.stripe_id)
  rescue ActiveRecord::RecordNotUnique
    update!
  end

  alias_method :create!, :created

  def updated
    record = StripeData::Payout.find_by!(stripe_id: @data.id)
    record.update!(record_fields)

    BalanceTransactionScheduler.call(record.id, record.stripe_id)
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
      arrival_date: Time.at(@data.arrival_date.to_i),
      balance_transaction: @data.balance_transaction,
      stripe_created: DateTime.strptime(@data.created.to_s, '%s'),
      currency: @data.currency,
      description: @data.description,
      destination: @data.destination,
      failure_balance_transaction: @data.failure_balance_transaction,
      failure_code: @data.failure_code,
      failure_message: @data.failure_message,
      livemode: @data.livemode,
      metadata: @data.metadata,
      method: @data.method,
      source_type: @data.source_type,
      statement_descriptor: @data.statement_descriptor,
      status: @data.status,
      stripe_type: @data.type
    }
  end
end
