zan = User.first
it_support = Project.find_by_name('IT Support')
facilities = Project.find_by_name('Facilities')

# Create dummy worker user for tests
worker = User.create(name: 'Johnny Worker', email: 'worker@sparcedge.com')

it_support.memberships.create(user: worker, role: 1)
facilities.memberships.create(user: worker, role: 1)

FactoryGirl.create(:ticket, submitter: zan, project: it_support)
FactoryGirl.create(:ticket, submitter: zan, project: facilities)
