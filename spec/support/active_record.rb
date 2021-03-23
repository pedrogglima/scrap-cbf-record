# frozen_string_literal: true

require 'active_record'

current_dir = File.dirname(__FILE__)

# config paths
db_dir = current_dir + '/../setup/db'
schema_file = db_dir + '/schema.rb'
db_config = YAML.load_file(db_dir + '/database.yml')

# add DatabaseTasks class to context 
include ActiveRecord::Tasks

# create db configs
DatabaseTasks.env = ENV['ENV'] || 'test'
DatabaseTasks.db_dir = db_dir
DatabaseTasks.database_configuration = db_config
database_configurations = DatabaseTasks.database_configuration

# pass db config to the constructor class
# w/ this set, DatabaseTasks won't find the db config to create the database
ActiveRecord::Base.configurations = DatabaseTasks.database_configuration

# create database from db config
DatabaseTasks.create_current('test')

# load schema into database
ActiveRecord::Tasks::DatabaseTasks.load_schema_current(
  :ruby,
  schema_file,
  'test'
)
