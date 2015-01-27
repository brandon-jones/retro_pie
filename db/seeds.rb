# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'seeding categories'
Category.create(name: "Pie")
Category.create(name: "Memory Card")
Category.create(name: "Controller")
Category.create(name: "Case")
Category.create(name: "HDMI cable")
Category.create(name: "Internet")

puts 'seeding status'
Status.create(name: "Canceled_Reversal", description: "A reversal has been canceled.")
Status.create(name: "Completed", description: "The payment has been completed.")
Status.create(name: "Created", description: "A payment is made using Express Checkout.")
Status.create(name: "Denied", description: "Payment has been denied.")
Status.create(name: "Expired", description: "This authorization has expired and cannot be captured.")
Status.create(name: "Failed", description: "The payment has failed.")
Status.create(name: "Pending", description: "The payment is pending.")
Status.create(name: "Refunded", description: "You refunded the payment.")
Status.create(name: "Reversed", description: "A payment was reversed due to a chargeback or other type of reversal.")
Status.create(name: "Processed", description: "A payment has been accepted.")
Status.create(name: "Voided", description: "This authorization has been voided.")
Status.create(name: "Shipped", description: "The PI has been shipped.")
Status.create(name: "Building", description: "I am building the PI.")
Status.create(name: "Unsubmitted", description: "Has not been submitted to paypal.")

puts 'filling faq'
faqs = YAML.load_file("config/faq.yml")
faqs.each do |faq|
	Faq.create(question: faq["question"],answer:  faq["answer"])
end

