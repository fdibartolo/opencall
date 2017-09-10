 # This seed contains data for all and/or specific envs.
 # As far as test env, will be used for the jasmine e2e specs thru 'rake protractor:spec_and_cleanup [nolog=y]'

# All envs
[RoleAdmin, RoleReviewer].each do |role_name|
  Role.create! name: role_name unless Role.exists?(name: role_name)
end

["Lecture", "Reporte de experiencia", "Workshop"].each do |track_name|
  Track.create! name: track_name unless Track.exists?(name: track_name)
end

%w[Principiantes Practicantes Expertos].each do |audience_name|
  Audience.create! name: audience_name unless Audience.exists?(name: audience_name)
end

["Enterprise Agile", "Liderazgo y aprendizaje", "Cultura y colaboración", "DevOps & Entrega continua", "Prácticas de desarrollo y pruebas automatizadas", "Experiencia de usuario", "Uso de agile fuera del desarrollo de software", "Innovación", "Startups & Emprendimiento"].each do |theme_name|
  Theme.create! name: theme_name unless Theme.exists?(name: theme_name)
end

# Test-specifif env
if Rails.env.test? or Rails.env.integration?
  User.create!([
    { first_name: 'Robert', last_name: 'Martin', country: 'US', email: 'bob@mail.com', password: '12345678', bio: 'my bio' },
    { first_name: 'Reviewer', last_name: 'Last', country: 'US', email: 'reviewer@mail.com', password: '12345678' },
    { first_name: 'Admin', last_name: 'Last', country: 'US', email: 'admin@mail.com', password: '12345678' }
  ])

  reviewer = User.find_by(email: 'reviewer@mail.com')
  reviewer.roles << Role.find_by(name: RoleReviewer)

  admin = User.find_by(email: 'admin@mail.com')
  admin.roles << Role.find_by(name: RoleAdmin)

  SessionProposal.create!([
    { user: User.last, title: 'Refactoring smells', summary: 'About refactoring', description: 'This session is about refactoring', theme: Theme.first, track: Track.first, audience: Audience.first, video_link: 'http://youtube.com/video_link' },
    { user: User.last, title: 'Test Driven Development', summary: 'About TDD', description: 'This session is about test driven development', theme: Theme.first, track: Track.first, audience: Audience.first, video_link: 'http://youtube.com/video_link' },
    { user: User.last, title: 'Craftmanship', summary: 'About craftmanship', description: 'This session is about software craftmanship', theme: Theme.first, track: Track.first, audience: Audience.first, video_link: 'http://youtube.com/video_link' }
  ])
end
