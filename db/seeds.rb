# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


c1 = Category.new(title: 'customer issue', description: 'customer problem to solve')
c2 =  Category.new(title: 'system issue', description: 'MS problem to solve')
c3 =  Category.new(title: 'customer issue', description: 'customer problem to solve')
c1.save
c2.save
c3.save

user1 = User.create(first_name: 'Mark', second_name: 'Lobster', email: 'test@test.com')
user2 = User.create(first_name: 'Spenser', second_name: 'Shrimp', email: 'test2@test.com')
user3 = User.create(first_name: 'Baker', second_name: 'Banks', email: 'test3@test.com')

user1.categories << c1
user2.categories << c2
user2.categories << c3
user3.categories << c1
user3.categories << c3

[{ title: 'issue_1', description: 'this first issue for test', issue_type: 'error', creator: 'system', category: c1 },
 { title: 'issue_2', description: 'this second issue for test', issue_type: 'customer_help', creator: 'Ms3', category: c2 },
 { title: 'issue_3', description: 'this third issue for test', issue_type: 'reply', creator: 'Ms2', category: c1 },
 { title: 'issue_4', description: 'this fourth issue for test', issue_type: 'help_neede', creator: 'MS1', category: c3 }
].each { |issue| Issue.create(issue) }
