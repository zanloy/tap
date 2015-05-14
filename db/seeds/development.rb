zan = User.first
it = Project.find_by_name('IT Support')
facilities = Project.find_by_name('Facilities')

FactoryGirl.create(:ticket, submitter: zan, project: it)
FactoryGirl.create(:ticket, submitter: zan, project: facilities)
