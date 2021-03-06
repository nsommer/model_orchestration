## 0.2.0 (Not released yet)

* Added the ability to pass instances of nested models to an orchestration model constructor in addition to argument hashes.
  
  See: https://github.com/nsommer/model_orchestration/issues/3
  
  If a nested model has already been instantiated you can pass it directly to the orchestration model constructor.

* Added `nested_models` class method to `ModelOrchestration::Base`.

  See: https://github.com/nsommer/model_orchestration/issues/1
  
  This method allows to specify multiple nested models with one method calls instead of calling `nested_model` every time.
  
* Added support for multiple dependencies per nested model.

  See: https://github.com/nsommer/model_orchestration/issues/2
  
  The class method `nested_model_dependency` now accepts an array as the `:to` key's value, containing multiple model identifiers the `:from` model depends on.
  
* Require ActiveSupport >= 5.0.1

  This fixes a warning issue.
  
  See: https://github.com/rails/rails/issues/26430

## 0.1.1

* Fixed a link in the documentation.

## 0.1.0

* First public release.
