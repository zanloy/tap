# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

zan = User.create(name: 'Zan Loy', email: 'zan.loy@sparcedge.com', role: 'admin')
justin = User.create(name: 'Justin Boykin', email: 'justin.boykin@sparcedge.com')
marc = User.create(name: 'Marc Murphy', email: 'marc.murphy@sparcedge.com')

it_support = Project.create(name: 'IT Support', show_in_navbar: true)
facilities = Project.create(name: 'Facilities', show_in_navbar: true)

it_support.memberships.create({user: zan, role: 4, admin: true})
it_support.memberships.create({user: marc, role: 4})
it_support.memberships.create({user: justin, role: 3})
facilities.memberships.create({user: zan, role: 5, admin: true})
facilities.memberships.create({user: marc, role: 4})
facilities.memberships.create({user: justin, role: 3})
