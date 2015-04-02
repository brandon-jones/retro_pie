# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'seeding categories'
Category.create(name: 'Pi')
Category.create(name: 'Case')
Category.create(name: 'Charger')
Category.create(name: 'Memory Card')
Category.create(name: 'Hdmi Cable')
Category.create(name: 'Controllers')
Category.create(name: 'Keyboard')
Category.create(name: 'Service Charge')
Category.create(name: 'Wifi')

puts 'seeding status'
Status.create(name: "Unsubmitted", description: 'I have not heard back on payment.')
Status.create(name: "Payment Processing", description: 'Payment has been submitted but not recieved.')
Status.create(name: "Payment Recieved", description: 'I have the payment will start building soon')
Status.create(name: "Payment Denied", description: 'We need to talk.')
Status.create(name: "Parts Ordered", description: 'Building will start soon.')
Status.create(name: "Building", description: 'I am working on your pi.')
Status.create(name: "Shipped", description: 'You should get your pi soon.')
Status.create(name: "Refuneded", description: 'You were unhappy.')
Status.create(name: "Closed", description: 'All is good.')

puts 'filling faq'
faqs = YAML.load_file("config/faq.yml")
faqs.each do |faq|
	Faq.create(question: faq["question"],answer:  faq["answer"])
end