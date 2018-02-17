module StreetSweeper
  class << self
    def parse(location, args = {})
      if Matchers.corner_regexp.match(location)
        parse_intersection(location, args)
      else
        parse_po_address(location, args) || parse_address(location, args) || parse_informal_address(location, args)
      end
    end

    def parse_address(address, args = {})
      matched = Matchers.address_regexp.match(address)
      return unless matched
      to_address(match_to_hash(matched), args)
    end

    def parse_po_address(address, args = {})
      matched = Matchers.po_address_regexp.match(address)
      return unless matched
      to_address(match_to_hash(matched), args)
    end

    def parse_informal_address(address, args = {})
      matched = Matchers.informal_address_regexp.match(address)
      return unless matched
      to_address(match_to_hash(matched), args)
    end

    def parse_intersection(intersection, args)
      matched = Matchers.intersection_regexp.match(intersection)
      return unless matched
      hash = match_to_hash(matched)

      streets = Matchers.intersection_regexp.named_captures['street'].map do |pos|
        matched[pos.to_i]
      end.select { |v| v }

      hash['street']  = streets[0] if streets[0]
      hash['street2'] = streets[1] if streets[1]

      street_types = Matchers.intersection_regexp.named_captures['street_type'].map do |pos|
        matched[pos.to_i]
      end.select { |v| v }

      hash['street_type']  = street_types[0] if street_types[0]
      hash['street_type2'] = street_types[1] if street_types[1]

      if hash['street_type'] && (!hash['street_type2'] || (hash['street_type'] == hash['street_type2']))
        type = hash['street_type'].clone
        hash['street_type'] = hash['street_type2'] = type if type.gsub!(/s\W*$/i, '') && /\A#{Matchers.street_type_regexp}\z/i =~ type
      end

      to_address(hash, args)
    end

    private

    def match_to_hash(matched)
      hash = {}
      matched.names.each { |name| hash[name] = matched[name] if matched[name] && !matched[name].strip.empty? }
      hash
    end

    def to_address(input, args)
      # strip off some punctuation and whitespace
      input.each_value do |string|
        string.strip!
        string.gsub!(/[^\w\s\-\#\&]/, '')
      end

      input['redundant_street_type'] = false
      if input['street'] && !input['street_type']
        matched = Matchers.street_regexp.match(input['street'])
        input['street_type'] = matched['street_type']
        input['redundant_street_type'] = true
      end

      ## abbreviate unit prefixes
      if input['unit_prefix']
        Constants::UNIT_ABBREVIATIONS.each_pair do |regex, abbr|
          regex.match(input['unit_prefix']) { |_m| input['unit_prefix'] = abbr }
        end
      end

      Constants::NORMALIZE_MAP.each_pair do |key, map|
        next unless input[key]
        mapping = map[input[key].downcase]
        input[key] = mapping if mapping
      end

      if args[:avoid_redundant_street_type]
        ['', '1', '2'].each do |suffix|
          street = input['street'      + suffix]
          type   = input['street_type' + suffix]
          next if !street || !type

          type_regexp = Matchers.street_type_matches[type.downcase]
          input.delete('street_type' + suffix) if type_regexp.match(street)
        end
      end

      # attempt to expand directional prefixes on place names
      if input['city']
        input['city'].gsub!(/^(#{Matchers.dircode_regexp})\s+(?=\S)/) do |match|
          Constants::DIRECTION_CODES[match[0].upcase] + ' '
        end
      end

      %w[street street_type street2 street_type2 city unit_prefix].each do |k|
        input[k] = input[k].split.map { |elem| upcase_or_capitalize(elem) }.join(' ') if input[k]
      end

      StreetSweeper::Address.new(input)
    end

    def upcase_or_capitalize(elem)
      return elem.upcase if elem.downcase =~ /^(po|ne|nw|sw|se)$/
      elem.capitalize
    end
  end
end
