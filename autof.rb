#Spam fraud

require 'stripe'
require 'faker'

def run_autof
  # Set API Key for Stripe
  Stripe.api_key = 'sk_test_51PVFrJQTCGmaIfRF1du7DVODNRW2rEjK7JdYXlDfsaNGRSh4yMPkUi9mw76Ueqk3A4GzuRrfFdGmsbh5A9G08EAs00GKaZHZTe'

  # List of payment methods to test
  payment_methods = [
    # 'pm_card_visa',
    # 'pm_card_visa_debit',
    # 'pm_card_mastercard',
    # 'pm_card_mastercard_debit',
    # 'pm_card_mastercard_prepaid',
    # 'pm_card_discover',
    # 'pm_card_amex',
    # 'pm_card_diners',
    # 'pm_card_jcb',
    # 'pm_card_unionpay',
    # 'pm_card_riskLevelElevated',
     'pm_card_riskLevelHighest',
    # 'pm_card_cvcCheckFail',
    # 'pm_card_createDispute',
    # 'pm_card_createDisputeInquiry',
    # 'pm_card_createMultipleDisputes',
    # 'pm_card_createDisputeProductNotReceived',
    # 'pm_card_visa_chargeDeclined',
    # 'pm_card_visa_chargeDeclinedInsufficientFunds',
    # 'pm_card_visa_chargeDeclinedLostCard',
    # 'pm_card_visa_chargeDeclinedStolenCard',
    # 'pm_card_chargeDeclinedExpiredCard',
    # 'pm_card_chargeDeclinedIncorrectCvc',
    # 'pm_card_chargeDeclinedProcessingError',
    # 'pm_card_visa_chargeDeclinedVelocityLimitExceeded',
    # 'pm_card_chargeCustomerFail',
    # 'pm_card_radarBlock',
    # 'pm_card_riskLevelHighest',
    # 'pm_card_riskLevelElevated',
    # 'pm_card_cvcCheckFail',
    # 'pm_card_avsZipFail',
    # 'pm_card_avsLine1Fail',
    # 'pm_card_avsFail',
    # 'pm_card_avsUnchecked'
  ]

  # Function to generate a random email with either predefined or random alphanumeric domain
  def generate_random_email
    predefined_domains = ['gmail.com', 'outlook.com', 'yahoo.com', 'hotmail.com']

    if rand(2).zero?
      Faker::Internet.email(domain: predefined_domains.sample)
    else
      Faker::Internet.email(domain: Faker::Alphanumeric.alpha(number: 10) + '.com')
    end
  end

  # Random email with random domain
  random_email = generate_random_email

  # Random payment method ID
  payment_method_id = payment_methods.sample

  # Extract description from payment method ID
  description = payment_method_id.split('_', 3).last

  # Random amount
  amount = rand(100..1000)

  begin
    # Create a Customer
    customer = Stripe::Customer.create({
      email: random_email
    })

    puts "Customer created: #{customer.id}"

    # Create and confirm a PaymentIntent
    payment_intent = Stripe::PaymentIntent.create({
      amount: amount,
      currency: 'usd',
      payment_method: payment_method_id,
      confirm: true,
      description: description,
      customer: customer.id,
      return_url: 'https://example.com/return'
    })

    puts "#Payment succeeded: #{payment_intent.id} using #{description} for $#{amount / 100.0}"
  rescue Stripe::StripeError => e
    puts "Error for #{payment_intent.id} with #{payment_method_id}: #{e.message}"
  end
end

run_autof