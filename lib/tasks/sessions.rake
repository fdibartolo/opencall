namespace :sessions do
  desc "Populates session_proposals with json data coming from the given path: 'rake sessions:generate[_file_path_]'"
  task :generate, [:params] => [:environment] do |t, args|
    file_name = args[:params]

    unless File.exists? file_name
      p "ERROR: No such file '#{file_name}'."
      exit
    end

    raw_sessions = JSON.parse IO.read(file_name)
    raw_sessions.each do |json_session|
      session = SessionProposal.new json_session
      session.user = User.last
      session.save!
    end
  end
end
