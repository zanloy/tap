module IntegrationSpecHelper
  def login(role: nil)
    if role
      user = FactoryGirl.create(:user, role.to_sym)
    else
      user = FactoryGirl.create(:user)
    end
    oauth_payload = {
      uid: 12345,
      info: { name: user.name, email: user.email },
      provider: 'google',
      credentials: { token: 'abc123', expires_at: 1.day.from_now }
    }
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, oauth_payload )
    visit '/auth/google_oauth2'
    return user
  end
end
