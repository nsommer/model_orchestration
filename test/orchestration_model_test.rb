require 'test_helper'

class A; end
class B; end

class OrchestrationWithCycle
  include ModelOrchestration::Base
  
  nested_model :a
  nested_model :b
end

# This test uses an orchestration model +UserOrgModel+ which has a nested
# user model and a nested org (short for organization) model, which have
# a n:1 relation.
#
# To keep it simple, the relation between user and org has been modeled by
# a user attribute :org. In an ActiveRecord data schema this would of course
# be modeled by a foreign key. However, I'm too lazy to add a real database
# and stuff to this test suite.
class OrchestrationModelTest < Minitest::Test
  def test_dependency_cylce_should_raise_error
    OrchestrationWithCycle.nested_model_dependency from: :a, to: :b
    
    assert_raises ModelOrchestration::DependencyCycleError do
      OrchestrationWithCycle.nested_model_dependency from: :b, to: :a
    end
  end
end