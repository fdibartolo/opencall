FactoryGirl.define do
  factory :user do
    first_name                  'Robert'
    last_name                   'Martin'
    country                     'US'
    sequence(:email) { |n| "#{first_name}.#{last_name}#{n}@main.com".downcase }
    password                    'unclebob'
    session_proposal_voted_ids  []

    factory :admin do
      after(:create) do |user|
        user.roles = [create(:role)]
      end
    end

    factory :reviewer do
      after(:create) do |user|
        user.roles = [create(:role, name: RoleReviewer)]
      end
    end
  end

  factory :identity do
    association :user, factory: :user
    provider    'github'
    uid         '123456'
    image_url   'http://some_url'
  end

  factory :session_proposal do
    title          'Refactoring'
    summary        'Session summary'
    description    'A long description for refactoring'
    association    :user, factory: :user, first_name: 'bob'
    # association    :track, factory: :track
    track_id       1
    audience_id    1
    theme_id       1
    audience_count 30
    video_link     'http://youtube.com/video_link'
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

  factory :role do
    name  RoleAdmin
  end

  factory :review do
    body        'some reviewer comment'
    score       7
    association :session_proposal, factory: :session_proposal
  end

  factory :track do
    # sequence(:name) {|n| n}
    name 'craftmanship'
  end

  factory :audience do
    name 'expert'
  end

  factory :theme do
    name 'technical'
  end
end
