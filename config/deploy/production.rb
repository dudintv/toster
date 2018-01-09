# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}

# role-based syntax
# ==================
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}

role :app, %w{deploy@5.45.122.18}
role :web, %w{deploy@5.45.122.18}
role :db, %w{deploy@5.45.122.18}

set :rails_env, :production
set :stage, :production

# Configuration
# =============

set :ssh_options, keys: %w(/Users/svetozar/.ssh/id_rsa),
                  forward_agent: true,
                  auth_methods: %w(publickey password),
                  port: 4321

server '5.45.122.18', user: 'deploy', roles: %w{web app db}, primary: true
