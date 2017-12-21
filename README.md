# Model Orchestration - orchestrating actions on related models ![Build Status](https://travis-ci.org/nsommer/model_orchestration.svg?branch=master)
Links: [GitHub](https://github.com/nsommer/model_orchestration) | [Travis CI](https://travis-ci.org/nsommer/model_orchestration) | [RubyGems](https://rubygems.org/gems/model_orchestration) | [RDocs](https://nsommer.github.io/model_orchestration/)

Have you ever collected multiple models (either [ActiveModel](http://api.rubyonrails.org/classes/ActiveModel/Model.html) or [ActiveRecord](http://api.rubyonrails.org/files/activerecord/README_rdoc.html)) in a controller method and had to orchestrate persisting them in the correct order? This library offers an elegant solution to this.

Create a new class, also called OrchestrationModel, which collects as many models as you like and orchestrates through validation and persistence operations. Use an easy to read DSL-like API to register nested models to this OrchestrationModel and their dependencies between each other. OrchestrationModels act like a container and behave just like an ActiveModel or ActiveRecord objects themselves. Therefore you can ceep controller methods simple without writing lots of code.

## Installing the Ruby Gem

If you use [bundler](http://bundler.io) (preferred), put model_orchestration into your applications `Gemfile`.

```ruby
gem "model_orchestration"
```

Otherwise you can of course install it globally with `gem install model_orchestration`.

## Example

Consider you're developing a B2B SaaS application with a signup form. When a new client signs up, you will probably need to create multiple models and save them to the database, for example a user object, representing the person signing up and an organization object which attaches the user to a legal entity which represents your customer, billing data etc.

*ModelOrchestration* allows you to nest the user model and the organization model into an OrchestrationModel, on which all the actions necessary can be performed (validation, persistence). Let's call this OrchestrationModel simply *Signup*.

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


## Development & Contributions

To start development on the model_orchestration itself, follow these steps.

```bash
git clone https://github.com/nsommer/model_orchestration.git
cd model_orchestration/
bundle install
```

You can run the tests with rake.

```bash
bundle exec rake
```

To build the rdoc files, run the corresponding rake task.

```bash
bundle exec rake rdoc
```

This generates the `docs` directory and puts all the documentation into it.

## Changelog

See `CHANGELOG.md`.

## License

Model Orchestration is released under the [MIT license](http://www.opensource.org/licenses/MIT).    
