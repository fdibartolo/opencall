FactoryGirl.define do
  factory :user do
    first_name  'Robert'
    last_name   'Martin'
    country     'US'
    email       'bob@mail.com'
    password    'unclebob'
  end

  factory :session_proposal do
    author      'Fowler'
    title       'Refactoring'
    description 'A long description for refactoring'
  end
end
