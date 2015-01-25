FactoryGirl.define do
  factory :user do
    first_name  'Robert'
    last_name   'Martin'
    country     'US'
    email       { "#{first_name}.#{last_name}@main.com".downcase }
    password    'unclebob'
  end

  factory :identity do
    association :user, factory: :user
    provider    'github'
    uid         '123456'
  end

  factory :session_proposal do
    title       'Refactoring'
    description 'A long description for refactoring'
    association :user, factory: :user, first_name: 'bob'

    factory :session_proposal_with_comment do
      after(:create) do |session_proposal|
        create(:comment, session_proposal: session_proposal)
      end
    end
  end

  factory :comment do
    body 'some comment'
    association :user, factory: :user, first_name: 'matt'
  end

  factory :tag do
    name 'xp'
  end
end
