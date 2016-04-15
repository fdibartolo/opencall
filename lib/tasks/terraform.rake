namespace :open_call do
  namespace :heroku do
    desc "Checks system requirements are met to build infrastructure"
    task :check_system_requirements do
      puts "Checking system requirements...".yellow

      result = `terraform -v`
      if $?.success?
        puts "#{result[0..-3]} is present".green
      else
        raise "Terraform is not installed. Follow installation instructions from 'https://www.terraform.io/intro/getting-started/install.html' before continuing".red
      end
    end

    desc "Creates an OpenCall instance on Heroku"
    task :create => [:check_system_requirements] do
      puts "About to build infrastructure; you are now being prompted for configuration variables:".yellow
      system("terraform apply")
    end

    desc "Destroy the OpenCall instance from Heroku"
    task :destroy => [:check_system_requirements] do
      puts "About to destroy infrastructure...".yellow
      system("terraform destroy")
    end
  end
end
