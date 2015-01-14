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
  end
end
