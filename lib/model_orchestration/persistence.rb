module ModelOrchestration
  ##
  # Including this module will give an OrchestrationModel::Base ActiveRecord-like
  # methods for perstistence. The methods available are restricted to
  # variations of save and create because updating/deleting/finding are
  # usually actions performed on a single record, not an orchestrated meta
  # model. 
  module Persistence
    extend ActiveSupport::Concern
    
    included do
      include ModelOrchestration::Base
    end
    
    module ClassMethods
      ##
      # See: http://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-create
      def create(attrs = {}, &block)
        object = new(attrs, &block)
        object.save
        object
      end
      
      ##
      # http://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-create-21
      def create!(attrs = {}, &block)
        object = new(attrs, &block)
        object.save!
        object
      end
    end
    
    ##
    # See: http://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save
    def save(*args)
      @nested_model_instances.each do |key, instance|
        return false unless instance.save(args)
      end
    
      true
    end
    
    ##
    # See: http://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21
    def save!(*args)
      @nested_model_instances.each do |key, instance|
        instance.save(args)
      end
    end
  end
end