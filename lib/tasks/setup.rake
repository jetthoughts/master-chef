desc 'sets up the project by running migration and populating sample data'
task :setup => :environment do
  raise 'do not run in production' if Rails.env.production?

  ["db:drop", "db:create", "db:migrate", "setup_sample_data"].each { |cmd| system "rake #{cmd}" }
end

desc 'Deletes all records and populates sample data'
task setup_sample_data: :environment do
  raise 'do not run in production' if Rails.env.production?

  delete_all_records_from_all_tables

  User.transaction do
    create_user email: 'john@example.com', super_admin: true
  end

  Project.create title: 'accounter', user_id: 1

  %w(Node\ #1 Node\ #2).each do |node|
    Node.create name: node, project_id: 1, credentials: {}.to_yaml
  end

  Deployment.create user_id: 1, node_id: 1, finished_at: 1.minute.since, success: false
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
