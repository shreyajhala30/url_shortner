FactoryBot.define do
  factory :url_datum do
    source_url { 'http://google.com' }
    # before :create, &:sanitize_url_and_assign_token
  end
end
