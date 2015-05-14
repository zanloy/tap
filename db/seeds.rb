# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

me = User.create(name: 'Zan Loy', email: 'zan.loy@sparcedge.com', role: 'admin')
Project.create(name: 'IT Support', owner: me)
Project.create(name: 'Facilities', owner: me)
