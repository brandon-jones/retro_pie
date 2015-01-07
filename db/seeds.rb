# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: "Pie")
Category.create(name: "Memory Card")
Category.create(name: "Controller")
Category.create(name: "Case")
Category.create(name: "HDMI cable")
Category.create(name: "Internet")

Status.create(name: "Unsubmitted")
Status.create(name: "Ordered")
Status.create(name: "Verified")
Status.create(name: "Waiting for Payment")
Status.create(name: "Building")
Status.create(name: "Shipped")
Status.create(name: "Returned")
Status.create(name: "Closed")