# Model Orchestration - orchestrating actions on related models ![Build Status](https://travis-ci.org/nsommer/model_orchestration.svg?branch=master)
Links: [GitHub](https://github.com/nsommer/model_orchestration) | [Travis CI](https://travis-ci.org/nsommer/model_orchestration) | [RubyGems](https://rubygems.org/gems/model_orchestration) | [RDocs](https://nsommer.github.io/model_orchestration/)

*ModelOrchestration* is a toolkit to help with orchestrating handling of multiple models that are related to each other.

The basic idea is to create a new model in which you can nest other models. You can declare relations between the nested models. The new orchestration model then provides interfaces for persistence actions, validations etc. Under the hood, the model orchestrates the save, validate etc. actions on all the nested models.

## Example

Consider you're developing a B2B SaaS application with a signup form. When a new client signs up, you will probably need to create multiple models and save them to the database, for example a user object, representing the person signing up and an organization object which attaches the user to a legal entity which represents your customer, billing data etc.

*ModelOrchestration* allows you to nest the user model and the organization model into a meta model, on which all the actions necessary can be performed (validation, persistence). Let's call this "meta model" simply *Signup*.

```ruby
class User < ActiveRecord::Base
  belongs_to :organization
  validates :name, presence: true
  validates :email, presence: true
end

class Organization < ActiveRecord::Base
  has_many :users
  validates :name, presence: true
end

class Signup
  include ModelOrchestration::Base
  include ModelOrchestration::Persistence

  nested_model :organization
  nested_model :user
  nested_model_dependency from: :user, to: :organization
end

signup = Signup.new(user: {name: "Nils", email: "nils@example.org"}, organization: {name: "Nils' Webdesign Agency"})

signup.valid? # => true

signup.user.name # => "Nils"
signup.user # => #<User:0x007f81f498d078> 
signup[:user][:email] # => "nils@example.org"

signup.save # => true
```

## Download and installation

The latest version of Orchestration Model can be installed with RubyGems:

```bash
gem install model_orchestration
```

The source code can be downloaded on GitHub

* https://github.com/nsommer/model_orchestration

## Development & Contributions

Contributions are welcome. Please use GitHub's issue tracker and pull requests to provide patches.

## License

Model Orchestration is released under the MIT license:

* http://www.opensource.org/licenses/MIT
    
