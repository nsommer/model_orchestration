require 'active_support/all'

##
# +ModelOrchestration+ is a toolkit to help with orchestrating handling
# of multiple models that are related to each other.
#
# The basic idea is to create a new model in which you can nest other models.
# You can declare relations between the nested models. The new orchestration
# model then provides interfaces for persistence actions, validations etc.
# Under the hood, the model orchestrates the save, validate etc. actions on
# all the nested models.
#
# Maybe it's easier to explain by using an example. Consider a web application
# where users can sign up and create an account. But instead of just creating
# a user account, you also want to attach them to an organization, e.g. to
# connect billing information which is shared between multiple users. Therefore
# you might want to create an employee model and a company model at the same
# time.
#
#   class Signup
#     include ModelOrchestration::Base
#     include ModelOrchestration::Persistence
#   
#     nested_model :company
#     nested_model :employee
#   
#     nested_model_dependency from: :employee, to: :company
#   end
#
# The Signup class prodives you with a lot of automatically generated methods
# that feel familiar from an ActiveModel/ActiveRecord perspective.
#
# For example, you automaticall get a constructor, that accepts an attributes
# hash which feeds the nested models.
#
#   signup = Signup.new(company: {name: "Foo Inc"}, employee: {name: "Bob"})
#
module ModelOrchestration
  extend ActiveSupport::Autoload
  
  autoload :Base
  autoload :Persistence
end