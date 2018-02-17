module StreetSweeper
  class Address
    attr_accessor(
      :number,
      :street,
      :street_type,
      :unit,
      :unit_prefix,
      :suffix,
      :prefix,
      :city,
      :state,
      :postal_code,
      :postal_code_ext,
      :street2,
      :street_type2,
      :suffix2,
      :prefix2,
      :redundant_street_type
    )

    def initialize(args)
      args.each do |attr, val|
        public_send("#{attr}=", val)
      end
    end

    def full_postal_code
      return nil unless postal_code
      postal_code_ext ? "#{postal_code}-#{postal_code_ext}" : postal_code
    end

    def state_fips
      Constants::FIPS_STATES[state]
    end

    def state_name
      (name = Constants::STATE_NAMES[state]) && name.capitalize
    end

    def intersection?
      !street2.nil?
    end

    def line1
      parts = []
      if intersection?
        parts << prefix if prefix
        parts << street
        parts << street_type if street_type
        parts << suffix if suffix
        parts << 'and'
        parts << prefix2 if prefix2
        parts << street2
        parts << street_type2 if street_type2
        parts << suffix2 if suffix2
      else
        parts << street_address_1
        parts << street_address_2
      end
      parts.join(' ').strip
    end

    def line2
      parts = []
      parts << city  if city
      parts << state if state
      s = parts.join(', ')
      s += " #{full_postal_code}" if full_postal_code
      s.strip
    end

    def street_address_1
      return line1 if intersection?
      parts = []
      parts << number
      parts << prefix if prefix
      parts << street if street
      parts << street_type if street_type && !redundant_street_type
      parts << suffix if suffix
      parts.join(' ').strip
    end

    def street_address_2
      parts = []
      parts << unit_prefix if unit_prefix
      parts << (unit_prefix ? unit : "\# #{unit}") if unit
      parts.join(' ').strip
    end

    def full_street_address
      [line1, line2].reject(&:empty?).join(', ')
    end

    def to_h
      instance_variables.each_with_object({}) do |var_name, hash|
        var_value = instance_variable_get(var_name)
        hash_name = var_name[1..-1].to_sym
        hash[hash_name] = var_value
      end
    end
  end
end
