zan = User.first
it_support = Project.find_by_name('IT Support')
facilities = Project.find_by_name('Facilities')

# Create dummy worker user for tests
worker = User.create(name: 'Johnny Worker', email: 'worker@sparcedge.com')

it_support.memberships.create(user: worker, role: 1)
facilities.memberships.create(user: worker, role: 1)

it_ticket = FactoryGirl.create(:ticket, reporter: zan, project: it_support)
facilities_ticket = FactoryGirl.create(:ticket, reporter: zan, project: facilities)

# Add Purchases
it_ticket.purchases.create(name: 'Samsung Galaxy DooDoo5', url: 'http://amazon.com', quantity: 1, cost: 249.99)
