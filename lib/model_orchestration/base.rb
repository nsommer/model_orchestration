module ModelOrchestration
  class DependencyCycleError < StandardError
  end
  
  ##
  # The module containing the base functionality. This includes class methods
  # to specify nested models and dependencies, as well as ActiveModel-like
  # functionality, such as attribute accessors for the nested models and 
  # validation methods.
  module Base
    extend ActiveSupport::Concern
    
    included do
      class_attribute :_nested_models, :_dependencies
      self._nested_models = []
      self._dependencies  = {}
    end
  
    module ClassMethods
      ##
      # Class method to declare a nested model. This invokes instantiation
      # of the model when the orchestration model is instantiated.
      # The nested model can be declared by symbol, type or string.
      #
      #   class HoldingClass
      #     include ModelOrchestration::Base
      #   
      #     nested_model :user
      #   end
      def nested_model(model)
        model_key = symbolize(model)
      
        self._nested_models << model_key
      end
      
      ##
      # Class method to declare nested models. This invokes instantiation
      # of the models when the orchestration model is instantiated.
      # The nested model can be declared by symbol, type or string.
      #
      #   class HoldingClass
      #     include ModelOrchestration::Base
      #   
      #     nested_models :user, :company
      #   end
      def nested_models(*models)
        models.each do |model|
          nested_model model
        end
      end
  
      ##
      # Class method to declare a dependency from one nested model to another.
      #
      #   class Signup
      #     include ModelOrchestration::Base
      #   
      #     nested_model :company
      #     nested_model :employee
      #   
      #     nested_model_dependency from: :employee, to: :company
      #   end
      #
      # The example obove might be used to orchestrate the signup process of
      # a user who creates an account representative for his company. In the
      # database schema, company and employee have a 1:n relation, which is
      # represented by +nested_model_dependency+.
      def nested_model_dependency(args = {})
        unless args.include?(:from) && args.include?(:to)
          raise ArgumentError, ":from and :to hash keys must be included."
        end
        
        from = symbolize(args[:from])
        to   = symbolize(args[:to])
        
        if dependency_introduces_cycle?(from, to)
          raise ModelOrchestration::DependencyCycleError, "#{from} is already a dependency of #{to}"
        end
    
        self._dependencies[from] = to
      end
    
      private
    
        def symbolize(arg)
          if arg.is_a? Symbol
            arg
          elsif arg.is_a? String
            arg.underscore.to_sym
          elsif arg.is_a? Class
            arg.name.underscore.to_sym
          else
            arg.to_s.underscore.to_sym
          end
        end
        
        def dependency_introduces_cycle?(from, to)
          self._dependencies.include?(to) && (self._dependencies[to] == from)
        end
    end
    
    ##
    # Instantiate the model and all nested models. Attributes can be submitted
    # as a hash and will be handed over to the nested models.
    def initialize(attrs = {})
      @nested_model_instances = {}
    
      self._nested_models.each do |model|
        klass = model.to_s.classify.constantize
      
        if attrs.include?(model)
          @nested_model_instances[model] = klass.new(attrs[model])
        else
          @nested_model_instances[model] = klass.new
        end
      end
    
      self._dependencies.each do |from, to|
        @nested_model_instances[from].public_send("#{to.to_s}=", @nested_model_instances[to])
      end
    end
  
    ##
    # Get a nested model by name (symbol).
    #
    #   class Signup
    #     include ModelOrchestration::Base
    #   
    #     nested_model :company
    #     nested_model :employee
    #   
    #     nested_model_dependency from: :employee, to: :company
    #   end
    #   
    #   signup  = Signup.new
    #   company = signup[:company]
    #
    # Because ActiveRecord classes also support the +[]+ method, it can
    # be chained to get attributes of nested models.
    #
    #   company_name = signup[:company][:name]
    #
    def [](key)
      send key
    end
    
    ##
    # Set a nested model by name (symbol).
    #
    #   class Signup
    #     include ModelOrchestration::Base
    #   
    #     nested_model :company
    #     nested_model :employee
    #   
    #     nested_model_dependency from: :employee, to: :company
    #   end
    #   
    #   signup  = Signup.new
    #   signup[:company] = Company.new
    def []=(key, value)
      send "#{key}=", value
    end
  
    ##
    # Implements attribute accessor methods for nested models.
    def method_missing(message, *args, &block)
      if @nested_model_instances.include?(message)
        # Get nested model accessor
        @nested_model_instances[message]
      elsif message =~ /^([^=]+)=$/
        # Set nested model accessor
        attr = message.to_s.chop.to_sym
        if @nested_model_instances.include?(attr)
          @nested_model_instances[attr] = args.first
        else
          super
        end
      else
        super
      end
    end
    
    ##
    # See: http://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-valid-3F
    def valid?(context = nil)
      valid = true
    
      @nested_model_instances.each do |key, instance|
        valid = false unless instance.valid?(context)
      end
  
      valid
    end
    
    ##
    # See: http://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validate
    alias_method :validate, :valid?
    
    # See: http://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-invalid-3F
    def invalid?(context = nil)
      !valid?(context)
    end
    
    ##
    # See: http://api.rubyonrails.org/classes/ActiveModel/Validations.html#method-i-validate-21
    def validate!(context = nil)
      valid?(context) || raise_validation_error
    end
    
    protected
    
      def raise_validation_error
        raise(ValidationError.new(self))
      end
  end
end