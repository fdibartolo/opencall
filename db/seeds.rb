 # This seed contains data for all and/or specific envs.
 # As far as test env, will be used for the jasmine e2e specs thru 'rake protractor:spec_and_cleanup [nolog=y]'

# All envs
[RoleAdmin, RoleReviewer].each do |role_name|
  Role.create! name: role_name unless Role.exists?(name: role_name)
end

%w[TrackA TrackB TrackC].each do |track_name|
  Track.create! name: track_name unless Track.exists?(name: track_name)
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
    { user: User.last, title: 'Refactoring smells', description: 'This session is about refactoring' },
    { user: User.last, title: 'Test Driven Development', description: 'This session is about test driven development' },
    { user: User.last, title: 'Craftmanship', description: 'This session is about software craftmanship' }
  ])
end