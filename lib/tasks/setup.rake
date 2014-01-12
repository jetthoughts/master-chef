desc 'sets up the project by running migration and populating sample data'
task :setup => :environment do
  raise 'do not run in production' if Rails.env.production?

  ["db:drop", "db:create", "db:migrate", "setup_sample_data"].each { |cmd| system "rake #{cmd}" }
end

desc 'Deletes all records and populates sample data'
task setup_sample_data: :environment do
  raise 'do not run in production' if Rails.env.production?

  delete_all_records_from_all_tables

  user = create_user(email: 'john@example.com', super_admin: true)
  project = Project.create title: 'Accounter', user_id: user.id, cookbooks: cookbooks_content

  nodes = %w(production staging).map do |node|
    Node.create! name:        node,
                 project_id:  project.id,
                 credentials: { 'hostname' => '77.120.57.83', 'user' => 'root', 'password' => ' ' }.to_yaml,
                 config:      node_config_content
  end

  Deployment.create user_id: user.id, node_id: nodes.first.id, finished_at: 1.minute.since, success: false
end

def create_user(options={})
  user_attributes = { email: 'john@example.com', password: 'welcome', first_name: "John", last_name: "Smith", role: "super_admin" }
  attributes = user_attributes.merge options
  User.create! attributes
end

def delete_all_records_from_all_tables
  Dir.glob(Rails.root + 'app/models/*.rb').each { |file| require file }
  ActiveRecord::Base.descendants.each { |klass| klass.delete_all }
end

def cookbooks_content
<<END
site :opscode

cookbook 'ntp'
cookbook 'timezone'
cookbook 'apt'
cookbook 'imagemagick'
cookbook 'build-essential'
cookbook 'chef_handler'
cookbook 'dmg'
cookbook 'git'
cookbook 'monit'
cookbook 'nginx'
cookbook 'nodejs'
cookbook 'ohai'
cookbook 'openssl'
cookbook 'postfix'
cookbook 'postgresql'
cookbook 'python'
cookbook 'rbenv'
cookbook 'memcached'
cookbook 'runit'
cookbook 'sudo'
cookbook 'watcher', git: 'https://github.com/Azrael808/chef-watcher.git'
cookbook 'windows'
cookbook 'yum'
cookbook 'logrotate'
cookbook 's3cmd'
cookbook 'ssl', git: 'https://github.com/miry/ssl-cookbook.git'
cookbook 'chef-solo-search'
END
end

def node_config_content
  <<END
{
  "domain": "accounter.com",

  "monit": {
    "notify_email": "root@accounter.com",

    "mail_format": {
      "from": "monit@accounter.com"
    }
  },

  "resolver": {
    "nameservers": [ "8.8.8.8" ]
  },

  "run_list": [ "recipe[nginx]" ],

  "postgresql": {
    "enable_pgdg_apt": "true",
    "version": "9.3",
    "dir": "/etc/postgresql/9.3/main",
    "password": { "postgres": "welcome" },
    "pidfile": "/var/run/postgresql/9.3-main.pid",
    "contrib": {
      "extensions": ["hstore"],
      "packages": ["postgresql-contrib-9.3"]
    },

    "config" : {
      "listen_addresses": "localhost",
      "log_rotation_age": "1d",
      "log_rotation_size": "10MB",
      "log_filename": "postgresql-%Y-%m-%d_%H%M%S.log"
    }

  },

  "ruby": { "version": "2.1.0" },

  "nginx": {
    "default_site_enabled": false,
    "user": "deployer",
    "group": "deployer"
  }
}

END
end
