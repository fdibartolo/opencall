namespace :open_call do
  namespace :vm do
    desc "Checks system requirements are met to provision virtual machine locally"
    task :check_system_requirements do
      puts "Checking system requirements...".yellow

      result = `vagrant -v`
      if $?.success?
        puts "Vagrant #{result[0..-2]} is present".green
      else
        raise "Vagrant is not installed. Follow installation instructions from 'https://www.vagrantup.com' before continuing".red
      end

      result = `vagrant plugin list`
      plugins = result.split("\n").map {|w| w.gsub(/\([^()]*\)/,"").strip}
      %w(vagrant-omnibus vagrant-berkshelf).each do |plugin|
        if plugins.include? plugin
          puts "Vagrant plugin #{plugin} is present".green
        else
          raise "Vagrant plugin '#{plugin}' is not installed. Please do so via ´vagrant plugin install #{plugin}´ before continuing".red
        end
      end
    end

    desc "Clones Chef cookbook with recipe to build virtual machine"
    task :clone_cookbook_repo do
      unless Dir.exist? "#{Rails.root}/vm_cookbook"
        puts "Cloning Chef cookbook...".yellow
        system "git clone https://github.com/fdibartolo/open_call_cookbook.git #{Rails.root}/vm_cookbook"
      else
        raise "Cookbook is already cloned, remove it before continuing".red
      end
    end
   
    desc "Creates Vagrantfile to spin up virtual machine"
    task :create_vagrantfile do
      unless File.exist? "#{Rails.root}/Vagrantfile"
        @cookbook_path = "#{Rails.root}/vm_cookbook"
        template = "#{Rails.root}/Vagrantfile.sample"

        puts "Generating Vagrantfile...".yellow
        erb = ERB.new(File.read(template))
        File.open("#{Rails.root}/Vagrantfile", 'w') {|f| f << erb.result()}
      else
        raise "Vagrantfile already exists, remove it before continuing".red
      end
    end
   
    desc "Setups virtual machine with all the needed software stack"
    task :setup => [:check_system_requirements, :clone_cookbook_repo, :create_vagrantfile] do
      puts "Setup completed successfully!".green
      puts "Please run ´vagrant up´ to spin up the virtual machine.".green
    end
  end
end