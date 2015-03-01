 # This seed contains data for all and/or specific envs.
 # As far as test env, will be used for the jasmine e2e specs thru 'rake protractor:spec_and_cleanup [nolog=y]'

# All envs
[RoleAdmin, RoleReviewer].each do |role_name|
  Role.create! name: role_name unless Role.exists?(name: role_name)
end

%w[TrackA TrackB TrackC].each do |track_name|
  Track.create! name: track_name unless Track.exists?(name: track_name)
end

%w[Principiantes Practicantes Expertos].each do |audience_name|
  Audience.create! name: audience_name unless Audience.exists?(name: audience_name)
end

# Test-specifif env
if Rails.env.test?
  User.create!({
    first_name: 'Robert',
    last_name:  'Martin',
    country:    'US',
    email:      'bob@mail.com',
    password:   '12345678'
  })

  SessionProposal.create!([
    { user: User.last, title: 'Refactoring smells', summary: 'About refactoring', description: 'This session is about refactoring', track: Track.first, audience: Audience.first },
    { user: User.last, title: 'Test Driven Development', summary: 'About TDD', description: 'This session is about test driven development', track: Track.first, audience: Audience.first },
    { user: User.last, title: 'Craftmanship', summary: 'About craftmanship', description: 'This session is about software craftmanship', track: Track.first, audience: Audience.first }
  ])
end