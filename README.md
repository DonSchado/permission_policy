# PermissionPolicy

* some description
* travis
* codeaclimate
* dependencies


## Authorization is hard

There are plenty of diferent solutions to this problem.
Because the requirements can be very difficult and as the system grows the problems become even worse. Exspecially when you need to support change.
The hardest part may be thight coupling and issues with encapsulation through the whole application.
To avoid repetitive and grwoing if/else branches you want a single responsible system.

In general, the permission policy defines and controls whether a current **object** (usually the user) can perform a specific **action** on a given **subject**. This decision is commonly based on one or more
factors:

* role
* type (or a set of attributes)
* enabled features / areas of the application


## Installation

Add this line to your application's Gemfile:

    gem 'permission_policy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install permission_policy

# API

todo: describe each public method

## Usage

You might want to configure which objects are needed for your permission handling.

```

  class ApplicationController < ActionController::Base
    # ...
    authorize_with :current_user
    verify_authorization! => which will raise an NotVerified Exception if authorized! wasn't called
    authorization_strategies :SuperAdminStrategy, :FeatureStrategy, :UnknownStrategy
    # ...
  end

```

The main idea is that strategies decide if they are responsible for authorization.
A "base strategy" defines the object API for all strategies which can be
used for permission checks. Each strategy should inherit from it and
implement `#match?` and `#allowed?`. But more on this under *customization*.

The permission_polciy is available in the controller layer of the application.
The public API is reduced to basicaly two methods:

* **#allowed?**

  Use it to receive a boolean response, whether the current user is allowed to
  access the requested feature in the current context.
  Usually, you would use it to check access in views and decorators.

  The first argument is the action you want to perform (either :view or :manage).
  As a second argument you can pass either a subject or a feature name:

  * ``` allowed? :view, subject: @entity```
    Would check if the user is allowed to perform action on the provided entity
  * ``` allowed? :view, feature: 'report' ```
    Would check if the user  is allowed to access the provided feature.


* **#authorize!**

  Same interface like ```#allowed?```, but instead of returning a boolean,
  it would raise an error if access is denied. Use it in your controllers,
  as the exception is rescued globally and would redirect user to root
  and display an access denied message.

  Example for subject based check:

  ```
        class EntityController < ApplicationController
          def edit
            @entity = current_user.entities.find(params[:id])
            authorize! :manage, subject: @entity
          end
        end
  ```

  Example for feature check:

  ```
        class ReportsController < ApplicationController
          before_action { authorize! :view, feature: 'report' }

          def index
            @report = current_user.report
          end
        end
  ```

---
### Authorization Customization

Each subject has it's own set of rules, described as a plain old ruby object,
which will be found by the policy when it responds to a common interface.
If an action is allowed will be decided either by a strategy directly or a separate class.

Rules should / can be placed under `models/permission_policy/rules/` and will
be called by the rules strategy defined in `strategies/rule_strategy.rb`.
At the moment you need to define one by yourself.

You can extend the permission policy by:

 - adding new actions to your rule classes
 - implement new rule classes for new subjects (entities)
 - implement new permission strategies, which help the policy to find the 'decider'


## possible ideas/improvements:

- support skip_verify_authorization only:/except: [:actions]
- register features and roles in the policy
- raise NoSuchFeature
- get available "permissions" for role/subject/feature

## Contributing

1. Fork it ( https://github.com/[my-github-username]/permission_policy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
