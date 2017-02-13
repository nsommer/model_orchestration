require 'minitest/autorun'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'model_orchestration'

require 'active_model'

class User
  include ActiveModel::Model
  validates :name, presence: true
  validates :age, presence: true
  validates :org, presence: true

  attr_accessor :name, :age, :org
end

class Org
  include ActiveModel::Model
  validates :name, presence: true

  attr_accessor :name, :place
end

class UserOrgModel
  include ModelOrchestration::Base

  nested_model :user
  nested_model :org
  nested_model_dependency from: :user, to: [:org]
end
