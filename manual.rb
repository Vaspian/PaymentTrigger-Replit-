#Spam fraud manually

require 'stripe'
require 'faker'

def run_manual
  # API Key
  Stripe.api_key = 'sk_test_51PU9Y8FaNmHtlXsurVR6L0DLCRn0YLsQORa2s1tdIx4emk2x7So8a8j8EYMgqveXLIB7K3QR19mDYVzxOVDJqccw001aD4nx7H'

  # Generate a random email using Faker
  random_email = Faker::Internet.unique.email

  # Define the payment method:
  #payment_method_id = 'pm_card_visa'
  #payment_method_id = 'pm_card_visa_debit'
  #payment_method_id = 'pm_card_mastercard'
  #payment_method_id = 'pm_card_mastercard_debit'
  #payment_method_id = 'pm_card_mastercard_prepaid'
  #payment_method_id = 'pm_card_discover'
  #payment_method_id = 'pm_card_amex'
  #payment_method_id = 'pm_card_diners'
  #payment_method_id = 'pm_card_jcb'
  #payment_method_id = 'pm_card_unionpay'
  #payment_method_id = 'pm_card_riskLevelElevated'
  payment_method_id = 'pm_card_riskLevelHighest'
  #payment_method_id = 'pm_card_cvcCheckFail'
  #payment_method_id = 'pm_card_createDispute'
  #payment_method_id = 'pm_card_createDisputeInquiry'
  #payment_method_id = 'pm_card_createMultipleDisputes'
  #payment_method_id = 'pm_card_createDisputeProductNotReceived'

  # Description pm_ name
  description = payment_method_id.split('_', 3).last

  begin
    # Create a Customer
    customer = Stripe::Customer.create({
      email: random_email
    })

    puts "Customer created: #{customer.id}"

    # Create and confirm a PaymentIntent
    payment_intent = Stripe::PaymentIntent.create({
      amount: 85000,
      currency: 'mxn',
      payment_method: 'pm_card_mx',
      confirm: true,
      customer: customer.id,
      return_url: 'https://example.com/return',
      payment_method_options: {
        card: {
          request_incremental_authorization: 'if_available'
        },
      },
    })

    puts "Payment succeeded: #{payment_intent.id} using #{description}"
  rescue Stripe::StripeError => e
    puts "Error for #{payment_intent.id} with #{description}: #{e.message}"
  end
end

run_manual