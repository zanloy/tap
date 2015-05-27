module Features
  module SessionHelpers
    def sign_in(role: nil)
      before(:each) do
        if role
          @current_user = create(:user, role.to_sym)
        else
          @current_user = create(:user)
        end
        oauth_payload = {
          uid: 12345,
          info: { name: @current_user.name, email: @current_user.email },
          provider: 'google',
          credentials: { token: 'abc123', expires_at: 1.day.from_now }
        }
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, oauth_payload )
        visit '/auth/google_oauth2'
      end
    end
  end
end
