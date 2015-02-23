namespace :open_call do
  namespace :sessions do
    desc "Populates session_proposals with json data coming from the given path: 'rake open_call:sessions:generate[_file_path_]'"
    task :generate, [:params] => [:environment] do |t, args|
      file_name = args[:params]

      unless File.exists? file_name
        p "ERROR: No such file '#{file_name}'."
        exit
      end

      min = Track.order(:id).pluck(:id).first
      max = Track.order(:id).pluck(:id).last

      raw_sessions = JSON.parse IO.read(file_name)
      raw_sessions.each do |json_session|
        session = SessionProposal.new json_session
        session.user = User.last
        session.track = Track.find_by(id: Random.rand(min..max)) || Track.first
        session.save!
      end
    end

    desc "Combines existing session proposals with existing tags"
    task :with_random_tags => :environment do 
      min = Tag.order(:id).pluck(:id).first
      max = Tag.order(:id).pluck(:id).last

      SessionProposal.all.each do |session_proposal|
        Random.rand(6).times do 
          tag = Tag.find_by(id: Random.rand(min..max))
          session_proposal.tags << tag if tag
        end
        session_proposal.save!
      end
    end
  end
  
  namespace :tags do
    desc "Populates tags with json data coming from the given path: 'rake open_call:tags:generate[_file_path_]'"
    task :generate, [:params] => [:environment] do |t, args|
      file_name = args[:params]

      unless File.exists? file_name
        p "ERROR: No such file '#{file_name}'."
        exit
      end

      raw_tags = JSON.parse IO.read(file_name)
      raw_tags.each { |json_tag| Tag.create! name: json_tag }
    end
  end

  namespace :sessions_with_tags do
    desc "Populates session and tags with json data coming from the given path: 'rake open_call:session_with_tags:generate[_file_path_]'"
    task :generate, [:params] => [:environment] do |t, args|
      file_name = args[:params]

      unless File.exists? file_name
        p "ERROR: No such file '#{file_name}'."
        exit
      end

      min = Track.order(:id).pluck(:id).first
      max = Track.order(:id).pluck(:id).last

      raw_sessions = JSON.parse IO.read(file_name)
      raw_sessions.each do |json_session|
        tags_name = json_session["tags"]
        json_session.delete_if {|k,v| k == "tags"}
        session = SessionProposal.new json_session
        tags_name.each do |name|
          tag = Tag.find_or_create_by(name: name)
          session.tags << tag
        end
        session.user = User.last
        session.track = Track.find_by(id: Random.rand(min..max)) || Track.first
        session.save!
      end
    end
  end
end