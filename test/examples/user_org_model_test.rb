require File.join(File.dirname(__FILE__), '..', '/test_helper')

# This test uses an orchestration model +UserOrgModel+ which has a nested
# user model and a nested org (short for organization) model, which have
# a n:1 relation.
#
# To keep it simple, the relation between user and org has been modeled by
# a user attribute :org. In an ActiveRecord data schema this would of course
# be modeled by a foreign key. However, I'm too lazy to add a real database
# and stuff to this test suite.
class UserOrgModelTest < Minitest::Test
  def setup
    user_attrs = {name: "Nils", age: 22}
    org_attrs  = {name: "Nils' Webdesign Agency"}
    @user_org_model = UserOrgModel.new(user: user_attrs, org: org_attrs)
  end
  
  def test_validity
    assert @user_org_model.valid?
  end
  
  def test_whether_invalidating_user_invalidates_user_org_model
    @user_org_model.user.name = nil
    assert !@user_org_model.valid?
  end
  
  def test_whether_invalidating_org_invalidates_user_org_model
    @user_org_model.org.name = nil
    assert !@user_org_model.valid?
  end
  
  def test_passing_nested_models_as_instances_to_orchestration_model
    user = User.new(name: "Nils", age: 22)
    org  = Org.new(name: "Nils' Webdesign Agency")
    @user_org_model = UserOrgModel.new(user: user, org: org)
    assert @user_org_model.valid?
  end
  
  def test_only_hashes_or_correctly_typed_instances_may_be_passed_to_orchestration_model
    assert_raises TypeError do
      @user_org_model = UserOrgModel.new(user: "String instead of User class", org: "String instead of Org class")
    end
  end
end
