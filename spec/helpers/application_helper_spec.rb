require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe '#display_breadcrumbs' do
    let(:crumbs) {
      [
        { text: 'Projects', link_to: '/projects' },
        { text: 'Support', link_to: '/projects/1' },
      ]
    }

    subject { helper.display_breadcrumbs(crumbs) }

    it { should have_link('Projects', href: '/projects') }
    it { should have_link('Support', href: '/projects/1') }
  end

  describe '#flash_class' do
    it 'handles :notice' do
      expect(helper.flash_class(:notice)).to eql('alert alert-info')
    end
    it 'handles :success' do
      expect(helper.flash_class(:success)).to eql('alert alert-success')
    end
    it 'handles :error' do
      expect(helper.flash_class(:error)).to eql('alert alert-error')
    end
    it 'handles :alert' do
      expect(helper.flash_class(:alert)).to eql('alert alert-error')
    end
  end

end
