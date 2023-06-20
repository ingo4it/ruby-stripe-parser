require 'rails_helper'

describe StripeData::CustomerEventHandler do
  let(:customer_json) { File.read(File.join(Rails.root, 'spec/event_handlers/customer.json')) }
  let(:customer) { Stripe::Event.construct_from(JSON.parse(customer_json, symbolize_names: true)) }
  let(:discount_json) { File.read(File.join(Rails.root, 'spec/event_handlers/discount.json')) }
  let(:discount) { Stripe::Event.construct_from(JSON.parse(discount_json, symbolize_names: true)) }

  it 'creates new customer' do
    expect { described_class.new(customer).send(:created) }.to change { StripeData::Customer.count }.by(1)
  end

  it 'deletes customer' do
    described_class.new(customer).send(:created)

    expect { described_class.new(customer).send(:deleted) }.to change { StripeData::Customer.count }.by(-1)
  end

  it 'updates customer' do
    described_class.new(customer).send(:created)
    customer_record = StripeData::Customer.find_by(stripe_id: customer.data.object.id)
    customer.data.object.currency = 'eur'

    expect { described_class.new(customer).send(:updated) }.to(
      change { customer_record.reload.currency }.to('eur')
    )
  end

  it 'creates discount' do
    described_class.new(customer).send(:created)
    customer_record = StripeData::Customer.find_by(stripe_id: customer.data.object.id)

    expect { described_class.new(discount).send(:discount_created) }.to(
      change { customer_record.reload.discount }
    )
  end

  it 'deletes discount' do
    described_class.new(customer).send(:created)
    described_class.new(discount).send(:discount_created)
    customer_record = StripeData::Customer.find_by(stripe_id: customer.data.object.id)

    expect { described_class.new(discount).send(:discount_deleted) }.to(
      change { customer_record.reload.discount }.to(nil)
    )
  end

  it 'updates discount' do
    described_class.new(customer).send(:created)
    described_class.new(discount).send(:discount_created)
    customer_record = StripeData::Customer.find_by(stripe_id: customer.data.object.id)
    discount.data.object.start = 1454436667

    expect { described_class.new(discount).send(:discount_updated) }.to(
      change { customer_record.reload.discount['start'] }.to(1454436667)
    )
  end
end
