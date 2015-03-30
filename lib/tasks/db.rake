namespace :db do
  desc "reset important tables"
  task :drop_data => :environment do
  	puts 'dropping orders'
  	Order.delete_all
  	puts 'dropping order items'
  	OrderItem.delete_all
  	puts 'dropping payments'
  	Payment.delete_all
  	puts 'dropping users'
  	User.delete_all
    puts 'dropping status'
    Status.delete_all
    puts 'dropping categories'
    Category.delete_all
  end

  task :myreset => :environment do
    puts 'dropping databse'
    `rake db:drop`
    puts 'creating database'
    `rake db:create`
    puts 'migrating database'
    `rake db:migrate`
    puts 'populating categories'
    `rake populate:categories`
    puts 'DONE!'
  end
end