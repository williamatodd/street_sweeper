module StreetSweeper
  module Matchers
    class << self
      attr_accessor(
        :street_type_regexp,
        :street_type_matches,
        :number_regexp,
        :fraction_regexp,
        :state_regexp,
        :city_and_state_regexp,
        :direct_regexp,
        :zip_regexp,
        :corner_regexp,
        :unit_regexp,
        :street_regexp,
        :po_street_regexp,
        :place_regexp,
        :address_regexp,
        :po_address_regexp,
        :informal_address_regexp,
        :dircode_regexp,
        :unit_prefix_numbered_regexp,
        :unit_prefix_unnumbered_regexp,
        :unit_regexp,
        :sep_regexp,
        :sep_avoid_unit_regexp,
        :intersection_regexp
      )
    end

    self.street_type_matches = {}
    Constants::STREET_TYPES.each_pair do |type, abbrv|
      street_type_matches[abbrv] = /\b (?: #{abbrv}|#{Regexp.quote(type)} ) \b/ix
    end

    self.street_type_regexp = Regexp.new(Constants::STREET_TYPES_LIST.keys.join('|'), Regexp::IGNORECASE)
    self.fraction_regexp = /\d+\/\d+/
    self.state_regexp = Regexp.new(
      '\b' + Constants::STATE_CODES.flatten.map { |code| Regexp.quote(code) }.join('|') + '\b',
      Regexp::IGNORECASE
    )
    self.direct_regexp = Regexp.new(
      (Constants::DIRECTIONAL.keys +
       Constants::DIRECTIONAL.values.sort do |a, b|
         b.length <=> a.length
       end.map do |c|
         f = c.gsub(/(\w)/, '\1.')
         [Regexp.quote(f), Regexp.quote(c)]
       end
      ).join('|'),
      Regexp::IGNORECASE
    )
    self.dircode_regexp = Regexp.new(Constants::DIRECTION_CODES.keys.join('|'), Regexp::IGNORECASE)
    self.zip_regexp     = /(?:(?<postal_code>\d{5})(?:-?(?<postal_code_ext>\d{4}))?)/
    self.corner_regexp  = /(?:\band\b|\bat\b|&|\@)/i

    # we don't include letters in the number regex because we want to
    # treat "42S" as "42 S" (42 South). For example,
    # Utah and Wisconsin have a more elaborate system of block numbering
    # http://en.wikipedia.org/wiki/House_number#Block_numbers
    self.number_regexp = /(?<number>\d+-?\d*)(?=\D)/ix

    # note that expressions like [^,]+ may scan more than you expect
    self.street_regexp = /
      (?:
        # special case for addresses like 14168 W River Rd and 3301 N Park
        # Blvd, where the street name matches one of the street types
        (?:
           (?<prefix> #{direct_regexp})\W+
           (?<street> [^\d]+)\W+
           (?<street_type> #{street_type_regexp})\b
        )
        |
        # special case for addresses like 100 South Street
        (?:(?<street> #{direct_regexp})\W+
           (?<street_type> #{street_type_regexp})\b
        )
        |
        (?:(?<prefix> #{direct_regexp})\W+)?
        (?:
          (?<street> [^,]*\d)
          (?:[^\w,]* (?<suffix> #{direct_regexp})\b)
          |
          (?<street> [^,]+)
          (?:[^\w,]+(?<street_type> #{street_type_regexp})\b)
          (?:[^\w,]+(?<suffix> #{direct_regexp})\b)?
          |
          (?<street> [^,]+?)
          (?:[^\w,]+(?<street_type> #{street_type_regexp})\b)?
          (?:[^\w,]+(?<suffix> #{direct_regexp})\b)?
        )
      )
    /ix

    self.po_street_regexp = /^(?<street>p\.?o\.?\s?(?:box|\#)?\s\d\d*[-a-z]*)/ix

    # http://pe.usps.com/text/pub28/pub28c2_003.htm
    self.unit_prefix_numbered_regexp = /
    (?<unit_prefix>
      #{Constants::UNIT_ABBREVIATIONS_NUMBERED.keys.join("|")}
    )(?![a-z])/ix

    self.unit_prefix_unnumbered_regexp = /
    (?<unit_prefix>
      #{Constants::UNIT_ABBREVIATIONS_UNNUMBERED.keys.join("|")}
    )\b/ix

    self.unit_regexp = /
      (?:
          (?: (?:#{unit_prefix_numbered_regexp} \W*)
              | (?<unit_prefix> \#)\W*
          )
          (?<unit> [\w-]+)
      )
      |
      #{unit_prefix_unnumbered_regexp}
    /ix

    self.city_and_state_regexp = /
      (?:
          (?<city> [^\d,]+?)\W+
          (?<state> #{state_regexp})
      )
    /ix

    self.place_regexp = /
      (?:#{city_and_state_regexp}\W*)? (?:#{zip_regexp})?
    /ix

    self.address_regexp = /
      \A
      [^\w\x23]*    # skip non-word chars except # (eg unit)
      #{number_regexp} \W*
      (?:#{fraction_regexp}\W*)?
      #{street_regexp}\W+
      (?:#{unit_regexp}\W+)?
      #{place_regexp}
      \W*         # require on non-word chars at end
      \z           # right up to end of string
    /ix

    self.po_address_regexp = /
      \A
      #{po_street_regexp} \W*
      #{place_regexp}
      \W*         # require on non-word chars at end
      \z           # right up to end of string
    /ix

    self.sep_regexp = /(?:\W+|\Z)/
    self.sep_avoid_unit_regexp = /(?:[^\#\w]+|\Z)/

    self.informal_address_regexp = /
      \A
      \s*         # skip leading whitespace
      (?:#{unit_regexp} #{sep_regexp})?
      (?:#{number_regexp})? \W*
      (?:#{fraction_regexp} \W*)?
      #{street_regexp} #{sep_avoid_unit_regexp}
      (?:#{unit_regexp} #{sep_regexp})?
      (?:#{place_regexp})?
      # don't require match to reach end of string
    /ix

    self.intersection_regexp = /\A\W*
      #{street_regexp}\W*?
      \s+#{corner_regexp}\s+
      #{street_regexp}\W+
      #{place_regexp}
      \W*\z
    /ix
  end
end
