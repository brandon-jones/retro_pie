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

puts 'seeding status'
Status.create(name: "Unsubmitted", description: 'I have not heard back on payment.')
Status.create(name: "Ordered", description: 'Got a payment will start building soon.')
Status.create(name: "Building", description: 'I have started building your PI')
Status.create(name: "Shipped", description: 'The PI has been shipped.')
Status.create(name: "Returned", description: 'The order was returned and maybe refuneded.')
Status.create(name: "Closed", description: 'The order was shipping and recieved.')

puts 'filling faq'
faqs = YAML.load_file("config/faq.yml")
faqs.each do |faq|
	Faq.create(question: faq["question"],answer:  faq["answer"])
end