module AttrLogics
  extend ActiveSupport::Concern
  included do
    class_attribute :attr_definitions
    self.attr_definitions = {}
  end

  class_methods do
    def define_logic(attr_name, &block)
      attr_definitions[attr_name] = block
      define_method "reset_#{attr_name}" do
        reset attr_name
      end

      define_method "fill_#{attr_name}" do
        fill attr_name
      end
    end
  end

  def reset(*attr_names)
    attr_names.flatten.each do |a|
      reset_one a
    end
  end

  # reset all attributes specified and then save
  def reset!(*attr_names)
    reset *attr_names
    save!
  end

  def reset_all
    reset attr_definitions.keys
  end

  # reset all attributes and then save
  def reset_all!
    reset_all
    save!
  end

  # reset one attribute and then save immediately
  def reset_one_by_one(*attr_names)
    attr_names.flatten.each do |a|
      reset a
      save!
    end
  end

  def reset_all_one_by_one
    reset_one_by_one attr_definitions.keys
  end

  # calculate specified attribute and return result and set
  def reset_one(attr_name)
    self[attr_name] = calc_attr(attr_name)
  end

  def reset_one!(attr_name)
    reset_one(attr_name)
    save!
  end

  # calculate specified attribute and return result
  def calc_attr(attr_name)
    raise "undefined attribute '#{attr_name}' calculation logic" unless attr_definitions[attr_name]

    instance_eval(&attr_definitions[attr_name])
  end

  # fill will not modify the value if it is already set
  def fill(*attr_names)
    attr_names.flatten.each do |a|
      fill_one a
    end
  end

  def fill!(*attr_names)
    fill *attr_names
    save!
  end

  def fill_all
    fill attr_definitions.keys
  end

  def fill_all!
    fill_all
    save!
  end

  # fill will not modify the value if it is already set
  def fill_one_by_one(*attr_names)
    attr_names.flatten.each do |a|
      fill_one a
      save!
    end
  end

  # fill will not modify the value if it is already set
  def fill_all_one_by_one
    fill_one_by_one attr_definitions.keys
  end

  # calculate specified attribute, and set it if it is not set
  # @param attr_name [String]
  def fill_one(attr_name)
    self[attr_name] ||= calc_attr(attr_name)
  end

  # @param attr_name [String]
  def fill_one!(attr_name)
    fill_one(attr_name)
    save!
  end
end
