zan = User.first
it_support = Project.find_by_name('IT Support')
facilities = Project.find_by_name('Facilities')

# Create dummy worker user for tests
worker = User.create(name: 'Johnny Worker', email: 'worker@sparcedge.com')
# Create luser for ticket entry
luser = User.create(name: 'Ann Luser', email: 'luser@sparcedge.com')

it_support.memberships.create(user: worker, role: 1)
facilities.memberships.create(user: worker, role: 1)

it_ticket = FactoryGirl.create(:ticket_with_purchases, :high, reporter: zan, project: it_support)
facilities_ticket = FactoryGirl.create(:ticket, :high, reporter: zan, project: facilities)

# Add Comments
FactoryGirl.create(:comment, ticket: it_ticket, user: zan)

# Add tons more!
FactoryGirl.create_list(:ticket, 50, project: it_support, reporter: luser)
FactoryGirl.create_list(:ticket, 51, project: facilities, reporter: luser)
