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
FactoryGirl.create_list(:purchase, 5, ticket: it_ticket)

# Add Comments
FactoryGirl.create(:comment, ticket: it_ticket, user: zan)
