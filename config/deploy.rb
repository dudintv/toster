# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "toster"
set :repo_url, "git@github.com:dudintv/toster.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/toster"

# Default value for :linked_files is []
append :linked_files, 'config/database.yml'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"
