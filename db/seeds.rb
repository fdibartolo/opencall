 # This seed is to be used in test env for the jasmine e2e specs thru 'rake protractor:spec_and_cleanup [nolog=y]'

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
