namespace :populate do
  desc "reset important tables"
  task :categories => :environment do
    Category.create(name: 'Pi')
    Category.create(name: 'Case')
    Category.create(name: 'Charger')
    Category.create(name: 'Memory Card')
    Category.create(name: 'Hdmi Cable')
    Category.create(name: 'Controllers')
    Category.create(name: 'Keyboard')
  end
end