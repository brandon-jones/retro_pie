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
  end
end