host = 'chico.seconddrawer.com.au'
user = 'deploy'
branch = 'master'
deploy_to = '/var/www/apps/controlr'

task :deploy => ['deploy:update', 'deploy:bundler', 'deploy:migrate', 'deploy:restart']

namespace :deploy do
  desc 'Update the source'
  task :update do
    system "ssh #{user}@#{host} 'cd #{deploy_to} && git fetch && git reset origin/#{branch} --hard'"
    puts Time.now
  end

  desc 'Rebuild the environment'
  task :bundler do
    sh "ssh #{user}@#{host} 'cd #{deploy_to} && bundle install --deployment'"
  end

  desc 'Migrate the database'
  task :migrate do
    sh "ssh #{user}@#{host} 'cd #{deploy_to} && RAILS_ENV=production rake db:autoupgrade'"
  end

  desc 'Restart Passenger'
  task :restart do
    sh "ssh #{user}@#{host} 'rm -f #{deploy_to}/public/stylesheets/*all.css && touch #{deploy_to}/tmp/restart.txt'"
  end

  desc 'Refresh the application'
  task :refresh => ['deploy:update', 'deploy:restart']

end

