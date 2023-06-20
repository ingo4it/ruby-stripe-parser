class CustomerEventHandler < EventHandler
  def initialize(event)
    @event = event
    @data = @event.data.object
  end

  def created
    StripeData::Customer.create!(record_fields)
  rescue ActiveRecord::RecordNotUnique
    update!
  end

  alias_method :create!, :created

  def deleted
    StripeData::Customer.find_by!(stripe_id: @data.id).delete
  rescue ActiveRecord::RecordNotFound
    # Record was not found, no need to delete it
  end

  def updated
    StripeData::Customer.find_by!(stripe_id: @data.id).update!(record_fields)
  rescue ActiveRecord::RecordNotFound
    create!
  end

  alias_method :update!, :updated

  def discount_created
    StripeData::Customer.find_by!(stripe_id: @data.customer).update!(discount: @data)
  rescue ActiveRecord::RecordNotFound
    # Customer was not found
  end

  def discount_deleted
    StripeData::Customer.find_by!(stripe_id: @data.customer).update!(discount: nil)
  rescue ActiveRecord::RecordNotFound
    # Customer was not found
  end

  def discount_updated
    discount_created
  end

  private

  def record_fields
    {
      stripe_id: @data.id,
      account_balance: @data.account_balance,
      currency: @data.currency,
      stripe_created: DateTime.strptime(@data.created.to_s, '%s'),
      default_source: @data.default_source,
      delinquent: @data.delinquent,
      # description: @data.description,
      discount: @data.discount,
      livemode: @data.livemode,
      metadata: @data.metadata,
      shipping: @data.shipping
    }
  end
end
