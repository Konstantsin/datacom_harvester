# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'datacom_harvester'
set :repo_url, 'git@github.com:Konstantsin/datacom_harvester.git'
set :scm, :git

set :deploy_to, "/home/ubuntu/#{fetch(:application)}"

set :linked_files, %w{config/datacom.yml config/sugarcrm.yml}

set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :finishing, 'deploy:cleanup'
end
