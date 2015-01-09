 # This seed is to be used in test env for the jasmine e2e specs thru 'rake protractor:spec_and_cleanup [nolog=y]'

User.create!({
  first_name: 'Robert',
  last_name:  'Martin',
  country:    'US',
  email:      'bob@mail.com',
  password:   '12345678'
})

SessionProposal.create!([
  { author: 'Fowler', title: 'Refactoring smells', description: 'This session is about refactoring' },
  { author: 'Beck', title: 'Test Driven Development', description: 'This session is about test driven development' },
  { author: 'Martin', title: 'Craftmanship', description: 'This session is about software craftmanship' }
])
