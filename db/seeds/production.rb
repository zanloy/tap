justin = User.create(name: 'Justin Boykin', email: 'justin.boykin@sparcedge.com')
marc = User.create(name: 'Marc Murphy', email: 'marc.murphy@sparcedge.com', executive: true)

it_support = Project.find_by(name: 'IT Support')
it_support.memberships.create({user: marc, role: 3})
it_support.memberships.create({user: justin, role: 3})

it_support = Project.find_by(name: 'Facilities')
facilities.memberships.create({user: marc, role: 3})
facilities.memberships.create({user: justin, role: 3})
