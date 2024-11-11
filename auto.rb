#Spam one-time payments

require 'stripe'
require 'faker'

def run_auto
  # API Key
  Stripe.api_key = TEST_SECRET_API_KEY_HERE

  # List of payment methods to test
  payment_methods = [
    'pm_card_visa',
    'pm_card_visa_debit',
    'pm_card_mastercard',
    'pm_card_mastercard_debit',
    'pm_card_mastercard_prepaid',
    'pm_card_discover',
    'pm_card_amex',
    'pm_card_diners',
    'pm_card_jcb',
    'pm_card_unionpay',
    'pm_card_visa_cartesBancaires',
    'pm_card_mastercard_cartesBancaires',
    'pm_card_visa_debit_eftposAuCoBranded',
    'pm_card_mastercard_debit_eftposAuCoBranded',
    'pm_card_ar',
    'pm_card_br',
    'pm_card_ca',
    'pm_card_cl',
    'pm_card_co',
    'pm_card_cr',
    'pm_card_ec',
    'pm_card_mx',
    'pm_card_pa',
    'pm_card_py',
    'pm_card_pe',
    'pm_card_uy',
    'pm_card_ae',
    'pm_card_ae_mastercard',
    'pm_card_at',
    'pm_card_be',
    'pm_card_bg',
    'pm_card_by',
    'pm_card_hr',
    'pm_card_cy',
    'pm_card_cz',
    'pm_card_dk',
    'pm_card_ee',
    'pm_card_fi',
    'pm_card_fr',
    'pm_card_de',
    'pm_card_gi',
    'pm_card_gr',
    'pm_card_hu',
    'pm_card_ie',
    'pm_card_it',
    'pm_card_lv',
    'pm_card_li',
    'pm_card_lt',
    'pm_card_lu',
    'pm_card_mt',
    'pm_card_nl',
    'pm_card_no',
    'pm_card_pl',
    'pm_card_pt',
    'pm_card_ro',
    'pm_card_si',
    'pm_card_sk',
    'pm_card_es',
    'pm_card_se',
    'pm_card_ch',
    'pm_card_gb',
    'pm_card_gb_debit',
    'pm_card_gb_mastercard',
    'pm_card_au',
    'pm_card_cn',
    'pm_card_hk',
    'pm_card_in',
    'pm_card_jp',
    'pm_card_jcb',
    'pm_card_my',
    'pm_card_nz',
    'pm_card_sg',
    'pm_card_tw',
    'pm_card_th_credit',
    'pm_card_th_debit',
    'pm_usBankAccount_success'
  ]

  # Random name
  random_name = Faker::Name.name

  # Generate email username based on random_name
  name_parts = random_name.downcase.split(' ')
  email_username = name_parts.join('_')

  # Random email with matching username
  random_email = "#{email_username}@#{['gmail.com', 'outlook.com', 'yahoo.com', 'hotmail.com'].sample}"

  # Random address generators
  random_city = Faker::Address.city
  random_street = Faker::Address.street_address
  random_zip = Faker::Address.zip_code
  random_state = Faker::Address.state_abbr
  random_country = Faker::Address.country_code

  # Generate a random order number using Faker
  order_number = Faker::Number.unique.number(digits: 4)

  # pm_ Randomizer
  payment_method_id = payment_methods.sample

  # Description pm_ name
  description = 'rplt_one_time'

  # Random amount:
  amount = rand(100..50000)

  begin
    # Create a Customer
    customer = Stripe::Customer.create({
      email: random_email,
      name: random_name,
      address: {
        country: random_country,
        state: random_state,
        city: random_city,
        line1: random_street,
        postal_code: random_zip
      }
    })

    puts "Customer created: #{customer.id}"

    # Create and confirm a PaymentIntent with Destination Charges
    payment_intent = Stripe::PaymentIntent.create({
      amount: amount, # randomized amount in cents
      currency: 'usd',
      payment_method: payment_method_id,
      confirm: true,
      description: description,
      customer: customer.id,
      return_url: 'https://example.com/return',
      metadata: {
        order: order_number
      }
    })

    puts "Payment succeeded: #{payment_intent.id} for $#{amount / 100.0}!"

  rescue Stripe::StripeError => e
    puts "Error for #{payment_intent&.id} with #{payment_method_id}: #{e.message}"
  end
end

run_auto