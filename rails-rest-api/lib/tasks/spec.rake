namespace :spec do
  desc 'Run all actor API tests'
  task :tc_actors do
    sh "RAILS_ENV=development rspec spec/api_testing/api_testing_rspec.rb -t tc_actors"
  end

  desc 'Run specific actor test by tag (usage: rake spec:actor[tc_get_actors_01])'
  task :tc_actor, [:tag] do |t, args|
    tag = args[:tag]
    if tag.nil?
      puts "Please provide a tag. Example: rake 'spec:actor[tc_get_actors_01]'"
      exit 1
    end
    sh "RAILS_ENV=development rspec spec/api_testing/api_testing_rspec.rb -t #{tag}"
  end
end

# Alias for convenience
task :spec => 'spec:actors'
