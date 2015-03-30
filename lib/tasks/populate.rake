namespace :populate do
  desc "reset important tables"
  task :required => :environment do
    Category.create(name: 'Pi')
    Category.create(name: 'Case')
    Category.create(name: 'Charger')
    Category.create(name: 'Memory Card')
    Category.create(name: 'Hdmi Cable')
    Category.create(name: 'Controllers')
    Category.create(name: 'Keyboard')
    Category.create(name: 'Service Charge')
    Status.create(name: 'Unsubmitted', description: 'This order has not been completed')
    Status.create(name: 'Submitted', description: 'This order has been submitted.')
  end
end