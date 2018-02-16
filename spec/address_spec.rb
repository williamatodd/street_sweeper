# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StreetAddress::US::Address do
  ADDRESSES = {
    '1005 Gravenstein Hwy 95472' => {
      line1: '1005 Gravenstein Hwy',
      line2: '95472',
      street_address_1: '1005 Gravenstein Hwy',
      street_address_2: ''
    },
    '1005 Gravenstein Hwy, 95472' => {
      line1: '1005 Gravenstein Hwy',
      line2: '95472',
      street_address_1: '1005 Gravenstein Hwy',
      street_address_2: ''
    },
    '1005 Gravenstein Hwy N, 95472' => {
      line1: '1005 Gravenstein Hwy N',
      line2: '95472',
      street_address_1: '1005 Gravenstein Hwy N',
      street_address_2: ''
    },
    '1005 Gravenstein Highway North, 95472' => {
      line1: '1005 Gravenstein Hwy N',
      line2: '95472',
      street_address_1: '1005 Gravenstein Hwy N',
      street_address_2: ''
    },
    '1005 N Gravenstein Highway, Sebastopol, CA' => {
      line1: '1005 N Gravenstein Hwy',
      line2: 'Sebastopol, CA',
      street_address_1: '1005 N Gravenstein Hwy',
      street_address_2: ''
    },
    '1005 N Gravenstein Highway, Suite 500, Sebastopol, CA' => {
      street_address_1: '1005 N Gravenstein Hwy',
      street_address_2: 'Ste 500',
      line1: '1005 N Gravenstein Hwy Ste 500',
      line2: 'Sebastopol, CA'
    },
    '1005 N Gravenstein Hwy Suite 500 Sebastopol, CA' => {
      line1: '1005 N Gravenstein Hwy Ste 500',
      line2: 'Sebastopol, CA',
      street_address_1: '1005 N Gravenstein Hwy',
      street_address_2: 'Ste 500'
    },
    '1005 N Gravenstein Highway, Sebastopol, CA, 95472' => {
      line1: '1005 N Gravenstein Hwy',
      line2: 'Sebastopol, CA 95472',
      street_address_1: '1005 N Gravenstein Hwy',
      street_address_2: ''
    },
    '1005 N Gravenstein Highway Sebastopol CA 95472' => {
      line1: '1005 N Gravenstein Hwy',
      line2: 'Sebastopol, CA 95472',
      street_address_1: '1005 N Gravenstein Hwy',
      street_address_2: ''
    },
    '1005 Gravenstein Hwy N Sebastopol CA' => {
      line1: '1005 Gravenstein Hwy N',
      line2: 'Sebastopol, CA',
      street_address_1: '1005 Gravenstein Hwy N',
      street_address_2: ''
    },
    '1005 Gravenstein Hwy N, Sebastopol CA' => {
      line1: '1005 Gravenstein Hwy N',
      line2: 'Sebastopol, CA',
      street_address_1: '1005 Gravenstein Hwy N',
      street_address_2: ''
    },
    '1005 Gravenstein Hwy, N Sebastopol CA' => {
      line1: '1005 Gravenstein Hwy',
      line2: 'North Sebastopol, CA',
      street_address_1: '1005 Gravenstein Hwy',
      street_address_2: ''
    },
    '1005 Gravenstein Hwy Sebastopol CA' => {
      line1: '1005 Gravenstein Hwy',
      line2: 'Sebastopol, CA',
      street_address_1: '1005 Gravenstein Hwy',
      street_address_2: ''
    },
    '115 Broadway San Francisco CA' => {
      line1: '115 Broadway',
      line2: 'San Francisco, CA',
      street_address_1: '115 Broadway',
      street_address_2: ''
    },
    '7800 Mill Station Rd, Sebastopol, CA 95472' => {
      line1: '7800 Mill Station Rd',
      line2: 'Sebastopol, CA 95472',
      street_address_1: '7800 Mill Station Rd',
      street_address_2: ''
    },
    '7800 Mill Station Rd Sebastopol CA 95472' => {
      line1: '7800 Mill Station Rd',
      line2: 'Sebastopol, CA 95472',
      street_address_1: '7800 Mill Station Rd',
      street_address_2: ''
    },
    '1005 State Highway 116 Sebastopol CA 95472' => {
      line1: '1005 State Highway 116',
      line2: 'Sebastopol, CA 95472',
      street_address_1: '1005 State Highway 116',
      street_address_2: ''
    },
    '1600 Pennsylvania Ave. NW Washington DC' => {
      line1: '1600 Pennsylvania Ave NW',
      line2: 'Washington, DC',
      street_address_1: '1600 Pennsylvania Ave NW',
      street_address_2: ''
    },
    '1600 Pennsylvania Avenue NW Washington DC' => {
      line1: '1600 Pennsylvania Ave NW',
      line2: 'Washington, DC',
      street_address_1: '1600 Pennsylvania Ave NW',
      street_address_2: ''
    },
    '48S 400E, Salt Lake City UT' => {
      line1: '48 S 400 E',
      line2: 'Salt Lake City, UT',
      street_address_1: '48 S 400 E',
      street_address_2: ''
    },
    '550 S 400 E #3206, Salt Lake City UT 84111' => {
      line1: '550 S 400 E # 3206',
      line2: 'Salt Lake City, UT 84111',
      street_address_1: '550 S 400 E',
      street_address_2: '# 3206'
    },
    '6641 N 2200 W Apt D304 Park City, UT 84098' => {
      line1: '6641 N 2200 W Apt D304',
      line2: 'Park City, UT 84098',
      street_address_1: '6641 N 2200 W',
      street_address_2: 'Apt D304'
    },
    '100 South St, Philadelphia, PA' => {
      line1: '100 South St',
      line2: 'Philadelphia, PA',
      street_address_1: '100 South St',
      street_address_2: ''
    },
    '100 S.E. Washington Ave, Minneapolis, MN' => {
      line1: '100 SE Washington Ave',
      line2: 'Minneapolis, MN',
      street_address_1: '100 SE Washington Ave',
      street_address_2: ''
    },
    '3813 1/2 Some Road, Los Angeles, CA' => {
      line1: '3813 Some Rd',
      line2: 'Los Angeles, CA',
      street_address_1: '3813 Some Rd',
      street_address_2: ''
    },
    '1 First St, e San Jose CA' => {
      line1: '1 First St',
      line2: 'East San Jose, CA',
      street_address_1: '1 First St',
      street_address_2: ''
    },
    'lt42 99 Some Road, Some City LA' => {
      line1: '99 Some Rd Lot 42',
      line2: 'Some City, LA',
      street_address_1: '99 Some Rd',
      street_address_2: 'Lot 42'
    },
    '36401 County Road 43, Eaton, CO 80615' => {
      line1: '36401 County Road 43',
      line2: 'Eaton, CO 80615',
      street_address_1: '36401 County Road 43',
      street_address_2: ''
    },
    '1234 COUNTY HWY 60E, Town, CO 12345' => {
      line1: '1234 County Hwy 60 E',
      line2: 'Town, CO 12345',
      street_address_1: '1234 County Hwy 60 E',
      street_address_2: ''
    },
    "'45 Quaker Ave, Ste 105'" => {
      line1: '45 Quaker Ave Ste 105',
      line2: '',
      street_address_1: '45 Quaker Ave',
      street_address_2: 'Ste 105'
    },
    '2730 S Veitch St Apt 207, Arlington, VA 22206' => {
      line1: '2730 S Veitch St Apt 207',
      line2: 'Arlington, VA 22206',
      street_address_1: '2730 S Veitch St',
      street_address_2: 'Apt 207'
    },
    '2730 S Veitch St #207, Arlington, VA 22206' => {
      line1: '2730 S Veitch St # 207',
      line2: 'Arlington, VA 22206',
      street_address_1: '2730 S Veitch St',
      street_address_2: '# 207'
    },
    '44 Canal Center Plaza Suite 500, Alexandria, VA 22314' => {
      line1: '44 Canal Center Plz Ste 500',
      line2: 'Alexandria, VA 22314',
      street_address_1: '44 Canal Center Plz',
      street_address_2: 'Ste 500'
    },
    'One East 161st Street, Bronx, NY 10451' => {
      line1: 'One East 161st St',
      line2: 'Bronx, NY 10451',
      street_address_1: 'One East 161st St',
      street_address_2: ''
    },
    'One East 161st Street Suite 10, Bronx, NY 10451' => {
      line1: 'One East 161st St Ste 10',
      line2: 'Bronx, NY 10451',
      street_address_1: 'One East 161st St',
      street_address_2: 'Ste 10'
    },
    'P.O. Box 280568 Queens Village, New York 11428' => {
      line1: 'PO Box 280568',
      line2: 'Queens Village, NY 11428',
      street_address_1: 'PO Box 280568',
      street_address_2: ''
    },
    'PO BOX 280568 Queens Village, New York 11428' => {
      line1: 'PO Box 280568',
      line2: 'Queens Village, NY 11428',
      street_address_1: 'PO Box 280568',
      street_address_2: ''
    },
    'PO 280568 Queens Village, New York 11428' => {
      line1: 'PO 280568',
      line2: 'Queens Village, NY 11428',
      street_address_1: 'PO 280568',
      street_address_2: ''
    },
    'Two Pennsylvania Plaza New York, NY 10121-0091' => {
      line1: 'Two Pennsylvania Plz',
      line2: 'New York, NY 10121-0091',
      street_address_1: 'Two Pennsylvania Plz',
      street_address_2: ''
    },
    '1400 CONNECTICUT AVE NW, WASHINGTON, DC 20036' => {
      line1: '1400 Connecticut Ave NW',
      line2: 'Washington, DC 20036',
      street_address_1: '1400 Connecticut Ave NW',
      street_address_2: ''
    }
  }.freeze

  INTERSECTIONS = {
    'Mission & Valencia San Francisco CA' => {
      line1: 'Mission and Valencia',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission and Valencia',
      street_address_2: ''
    },
    'Mission & Valencia, San Francisco CA' => {
      line1: 'Mission and Valencia',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission and Valencia',
      street_address_2: ''
    },
    'Mission St and Valencia St San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission St and Valencia St',
      street_address_2: ''
    },
    'Hollywood Blvd and Vine St Los Angeles, CA' => {
      line1: 'Hollywood Blvd and Vine St',
      line2: 'Los Angeles, CA',
      street_address_1: 'Hollywood Blvd and Vine St',
      street_address_2: ''
    },
    'Mission St & Valencia St San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission St and Valencia St',
      street_address_2: ''
    },
    'Mission and Valencia Sts San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission St and Valencia St',
      street_address_2: ''
    },
    'Mission & Valencia Sts. San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission St and Valencia St',
      street_address_2: ''
    },
    'Mission & Valencia Streets San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission St and Valencia St',
      street_address_2: ''
    },
    'Mission Avenue and Valencia Street San Francisco CA' => {
      line1: 'Mission Ave and Valencia St',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission Ave and Valencia St',
      street_address_2: ''
    }
  }.freeze

  INFORMAL_ADDRESSES = {
    '#42 233 S Wacker Dr 60606' => {
      line1: '233 S Wacker Dr # 42',
      line2: '60606',
      street_address_1: '233 S Wacker Dr',
      street_address_2: '# 42'
    },
    'Apt. 42, 233 S Wacker Dr 60606' => {
      line1: '233 S Wacker Dr Apt 42',
      line2: '60606',
      street_address_1: '233 S Wacker Dr',
      street_address_2: 'Apt 42'
    },
    '2730 S Veitch St #207' => {
      line1: '2730 S Veitch St # 207',
      line2: '',
      street_address_1: '2730 S Veitch St',
      street_address_2: '# 207'
    },
    '321 S. Washington' => {
      line1: '321 S Washington',
      line2: '',
      street_address_1: '321 S Washington',
      street_address_2: ''
    },
    '233 S Wacker Dr lobby 60606' => {
      line1: '233 S Wacker Dr Lbby',
      line2: '60606',
      street_address_1: '233 S Wacker Dr',
      street_address_2: 'Lbby'
    }
  }.freeze

  %w[line1 line2 street_address_1 street_address_2].each do |attribute|
    describe "##{attribute}" do
      ADDRESSES.each_pair do |address, expected|
        next if expected["#{attribute}".to_sym] == ''
        context "receiving a valid address: #{address}" do
          it "returns #{expected["#{attribute}".to_sym]}" do
            addr = StreetAddress::US.parse(address)
            expect(addr.send("#{attribute}")).to eq(expected["#{attribute}".to_sym])
          end
        end
      end

      describe "##{attribute}" do
        INTERSECTIONS.each_pair do |address, expected|
          context "receiving a valid intersection: #{address}" do
            it "returns #{expected["#{attribute}".to_sym]}" do
              addr = StreetAddress::US.parse(address)
              expect(addr.send("#{attribute}")).to eq(expected["#{attribute}".to_sym])
            end
          end
        end
      end

      INFORMAL_ADDRESSES.each_pair do |address, expected|
        next if expected["#{attribute}".to_sym] == ''
        context "receiving a valid informal address: #{address}" do
          it "returns #{expected["#{attribute}".to_sym]}" do
            addr = StreetAddress::US.parse(address)
            expect(addr.send("#{attribute}")).to eq(expected["#{attribute}".to_sym])
          end
        end
      end
    end
  end

  describe '#to_s' do
    ADDRESSES.each_pair do |address, expected|
      context "receiving a valid address: #{address}" do
        it "returns #{[expected[:line1], expected[:line2]].reject(&:empty?).join(', ')}" do
          expected_result = expected[:to_s]
          expected_result ||= [expected[:line1], expected[:line2]].reject(&:empty?).join(', ')
          addr = StreetAddress::US.parse(address)
          expect(addr.to_s).to eq(expected_result)
        end
      end
    end

    INTERSECTIONS.each_pair do |address, expected|
      context "receiving a valid intersection: #{address}" do
        it "returns #{[expected[:line1], expected[:line2]].reject(&:empty?).join(', ')}" do
          expected_result = expected[:to_s]
          expected_result ||= [expected[:line1], expected[:line2]].reject(&:empty?).join(', ')
          addr = StreetAddress::US.parse(address)
          expect(addr.to_s).to eq(expected_result)
        end
      end
    end

    INFORMAL_ADDRESSES.each_pair do |address, expected|
      context "receiving a valid informal address: #{address}" do
        it "returns #{[expected[:line1], expected[:line2]].reject(&:empty?).join(', ')}" do
          expected_result = expected[:to_s]
          expected_result ||= [expected[:line1], expected[:line2]].reject(&:empty?).join(', ')
          informal_addr = StreetAddress::US.parse_informal_address(address)
          expect(informal_addr.to_s).to eq(expected_result)
        end
      end
    end

    it 'without line2 value' do
      address = '45 Quaker Ave, Ste 105'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s).to eq('45 Quaker Ave Ste 105')
    end

    it 'with valid addresses with zip_ext' do
      address = '7800 Mill Station Rd Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s).to eq('7800 Mill Station Rd, Sebastopol, CA 95472-1234')
    end

    it '[:line1]' do
      address = '7800 Mill Station Rd Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s(:line1)).to eq('7800 Mill Station Rd')
    end

    it '[:line2]' do
      address = '7800 Mill Station Rd Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s(:line2)).to eq('Sebastopol, CA 95472-1234')
    end

    it '[:street_address_1]' do
      address = '7800 Mill Station Rd, Apt. 7B, Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s(:street_address_1)).to eq('7800 Mill Station Rd')
    end

    it '[:street_address_2]' do
      address = '7800 Mill Station Rd, Apartment. 7B, Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s(:street_address_2)).to eq('Apt 7B')
    end

    it '[:city_state_zip]' do
      address = '7800 Mill Station Rd Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s(:city_state_zip)).to eq('Sebastopol, CA 95472-1234')
    end

    it '[:line1] and a PO Box' do
      address = 'PO 7800 Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s(:line1)).to eq('PO 7800')
    end
  end

  describe '#full_postal_code' do
    it 'with a full postal code' do
      address = '7800 Mill Station Rd Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.full_postal_code).to eq('95472-1234')
    end

    it 'with only the first five' do
      address = '7800 Mill Station Rd Sebastopol CA 95472'
      addr = StreetAddress::US.parse(address)
      expect(addr.full_postal_code).to eq('95472')
    end
  end

  describe '#postal_code_ext' do
    it 'no postal code' do
      address = '7800 Mill Station Rd Sebastopol CA'
      addr = StreetAddress::US.parse(address)
      expect(addr.full_postal_code).to be_nil
    end

    it 'with valid zip plus 4 with dash' do
      addr = StreetAddress::US.parse('2730 S Veitch St, Arlington, VA 22206-3333')
      expect(addr.postal_code_ext).to eq('3333')
    end

    it 'with valid zip plus 4 without dash' do
      addr = StreetAddress::US.parse('2730 S Veitch St, Arlington, VA 222064444')
      expect(addr.postal_code_ext).to eq('4444')
    end
  end

  describe '#intersection?' do
    ADDRESSES.each_pair do |address, expected|
      context "with standard address: #{address}" do
        let(:parsed_address) { StreetAddress::US.parse(address) }

        it 'returns false' do
          expect(parsed_address.intersection?).to be false
        end
      end
    end

    INTERSECTIONS.each_pair do |address, expected|
      context "with intersection: #{address}" do
        let(:parsed_address) { StreetAddress::US.parse(address) }

        it 'returns true' do
          expect(parsed_address.intersection?).to be true
        end
      end
    end

    INFORMAL_ADDRESSES.each_pair do |address, expected|
      context "with informal address: #{address}" do
        let(:parsed_address) { StreetAddress::US.parse(address) }

        it 'returns false' do
          expect(parsed_address.intersection?).to be false
        end
      end
    end
  end
end
