desc "This task is called by the Heroku scheduler add-on"
task :pull_data => :environment do
  puts "Pulling data from Departure Vision"
  NJTransit::ScheduleSucker.run
  puts "Done"
end
