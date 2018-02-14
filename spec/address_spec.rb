# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StreetAddress::US::Address do
  ADDRESSES = {
    '1005 Gravenstein Hwy 95472' => {
      line1: '1005 Gravenstein Hwy',
      line2: '95472'
    },
    '1005 Gravenstein Hwy, 95472' => {
      line1: '1005 Gravenstein Hwy',
      line2: '95472'
    },
    '1005 Gravenstein Hwy N, 95472' => {
      line1: '1005 Gravenstein Hwy N',
      line2: '95472'
    },
    '1005 Gravenstein Highway North, 95472' => {
      line1: '1005 Gravenstein Hwy N',
      line2: '95472'
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
      line2: 'Sebastopol, CA'
    },
    '1005 N Gravenstein Highway, Sebastopol, CA, 95472' => {
      line1: '1005 N Gravenstein Hwy',
      line2: 'Sebastopol, CA 95472'
    },
    '1005 N Gravenstein Highway Sebastopol CA 95472' => {
      line1: '1005 N Gravenstein Hwy',
      line2: 'Sebastopol, CA 95472'
    },
    '1005 Gravenstein Hwy N Sebastopol CA' => {
      line1: '1005 Gravenstein Hwy N',
      line2: 'Sebastopol, CA'
    },
    '1005 Gravenstein Hwy N, Sebastopol CA' => {
      line1: '1005 Gravenstein Hwy N',
      line2: 'Sebastopol, CA'
    },
    '1005 Gravenstein Hwy, N Sebastopol CA' => {
      line1: '1005 Gravenstein Hwy',
      line2: 'North Sebastopol, CA'
    },
    '1005 Gravenstein Hwy Sebastopol CA' => {
      line1: '1005 Gravenstein Hwy',
      line2: 'Sebastopol, CA'
    },
    '115 Broadway San Francisco CA' => {
      line1: '115 Broadway',
      line2: 'San Francisco, CA'
    },
    '7800 Mill Station Rd, Sebastopol, CA 95472' => {
      line1: '7800 Mill Station Rd',
      line2: 'Sebastopol, CA 95472'
    },
    '7800 Mill Station Rd Sebastopol CA 95472' => {
      line1: '7800 Mill Station Rd',
      line2: 'Sebastopol, CA 95472'
    },
    '1005 State Highway 116 Sebastopol CA 95472' => {
      line1: '1005 State Highway 116',
      line2: 'Sebastopol, CA 95472'
    },
    '1600 Pennsylvania Ave. Washington DC' => {
      line1: '1600 Pennsylvania Ave',
      line2: 'Washington, DC'
    },
    '1600 Pennsylvania Avenue Washington DC' => {
      line1: '1600 Pennsylvania Ave',
      line2: 'Washington, DC'
    },
    '48S 400E, Salt Lake City UT' => {
      line1: '48 S 400 E',
      line2: 'Salt Lake City, UT'
    },
    '550 S 400 E #3206, Salt Lake City UT 84111' => {
      line1: '550 S 400 E # 3206',
      line2: 'Salt Lake City, UT 84111'
    },
    '6641 N 2200 W Apt D304 Park City, UT 84098' => {
      line1: '6641 N 2200 W Apt D304',
      line2: 'Park City, UT 84098'
    },
    '100 South St, Philadelphia, PA' => {
      line1: '100 South St',
      line2: 'Philadelphia, PA'
    },
    '100 S.E. Washington Ave, Minneapolis, MN' => {
      line1: '100 SE Washington Ave',
      line2: 'Minneapolis, MN'
    },
    '3813 1/2 Some Road, Los Angeles, CA' => {
      line1: '3813 Some Rd',
      line2: 'Los Angeles, CA'
    },
    '1 First St, e San Jose CA' => {
      line1: '1 First St',
      line2: 'East San Jose, CA'
    },
    'lt42 99 Some Road, Some City LA' => {
      line1: '99 Some Rd Lot 42',
      line2: 'Some City, LA'
    },
    '36401 County Road 43, Eaton, CO 80615' => {
      line1: '36401 County Road 43',
      line2: 'Eaton, CO 80615'
    },
    '1234 COUNTY HWY 60E, Town, CO 12345' => {
      line1: '1234 County Hwy 60 E',
      line2: 'Town, CO 12345'
    },
    "'45 Quaker Ave, Ste 105'" => {
      line1: '45 Quaker Ave Ste 105',
      line2: ''
    },
    '2730 S Veitch St Apt 207, Arlington, VA 22206' => {
      line1: '2730 S Veitch St Apt 207',
      line2: 'Arlington, VA 22206'
    },
    '2730 S Veitch St #207, Arlington, VA 22206' => {
      line1: '2730 S Veitch St # 207',
      line2: 'Arlington, VA 22206'
    },
    '44 Canal Center Plaza Suite 500, Alexandria, VA 22314' => {
      line1: '44 Canal Center Plz Ste 500',
      line2: 'Alexandria, VA 22314'
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
      line2: 'Queens Village, NY 11428'
    },
    'PO BOX 280568 Queens Village, New York 11428' => {
      line1: 'PO Box 280568',
      line2: 'Queens Village, NY 11428',
      street_address_1: 'PO Box 280568',
      street_address_2: ''
    },
    'PO 280568 Queens Village, New York 11428' => {
      line1: 'PO 280568',
      line2: 'Queens Village, NY 11428'
    },
    'Two Pennsylvania Plaza New York, NY 10121-0091' => {
      line1: 'Two Pennsylvania Plz',
      line2: 'New York, NY 10121-0091'
    },
    '1400 CONNECTICUT AVE NW, WASHINGTON, DC 20036' => {
      line1: '1400 Connecticut Ave NW',
      line2: 'Washington, DC 20036'
    }
  }.freeze

  INTERSECTIONS = {
    'Mission & Valencia San Francisco CA' => {
      line1: 'Mission and Valencia',
      line2: 'San Francisco, CA'
    },
    'Mission & Valencia, San Francisco CA' => {
      line1: 'Mission and Valencia',
      line2: 'San Francisco, CA'
    },
    'Mission St and Valencia St San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA'
    },
    'Hollywood Blvd and Vine St Los Angeles, CA' => {
      line1: 'Hollywood Blvd and Vine St',
      line2: 'Los Angeles, CA'
    },
    'Mission St & Valencia St San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA'
    },
    'Mission and Valencia Sts San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA'
    },
    'Mission & Valencia Sts. San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA'
    },
    'Mission & Valencia Streets San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA'
    },
    'Mission Avenue and Valencia Street San Francisco CA' => {
      line1: 'Mission Ave and Valencia St',
      line2: 'San Francisco, CA'
    }
  }.freeze

  INFORMAL_ADDRESSES = {
    '#42 233 S Wacker Dr 60606' => {
      line1: '233 S Wacker Dr # 42',
      line2: '60606'
    },
    'Apt. 42, 233 S Wacker Dr 60606' => {
      line1: '233 S Wacker Dr Apt 42',
      line2: '60606'
    },
    '2730 S Veitch St #207' => {
      line1: '2730 S Veitch St # 207',
      line2: ''
    },
    '321 S. Washington' => {
      line1: '321 S Washington',
      line2: ''
    },
    '233 S Wacker Dr lobby 60606' => {
      line1: '233 S Wacker Dr Lbby',
      line2: '60606'
    }
  }.freeze

  describe '#line_1' do
    ADDRESSES.each_pair do |address, expected|
      it "with valid address: #{address}" do
        addr = StreetAddress::US.parse(address)
        expect(addr.line1).to eq(expected[:line1])
      end
    end

    INTERSECTIONS.each_pair do |address, expected|
      it "with intersection: #{address}" do
        addr = StreetAddress::US.parse(address)
        expect(addr.line1).to eq(expected[:line1])
      end
    end

    INFORMAL_ADDRESSES.each_pair do |address, expected|
      it "with informal address: #{address}" do
        informal_addr = StreetAddress::US.parse_informal_address(address)
        expect(informal_addr.line1).to eq(expected[:line1])
      end
    end
  end

  describe '#line2' do
    ADDRESSES.each_pair do |address, expected|
      it "with valid address: #{address}" do
        addr = StreetAddress::US.parse(address)
        expect(addr.line2).to eq(expected[:line2])
      end
    end

    INTERSECTIONS.each_pair do |address, expected|
      it "with intersection: #{address}" do
        addr = StreetAddress::US.parse(address)
        expect(addr.line2).to eq(expected[:line2])
      end
    end

    INFORMAL_ADDRESSES.each_pair do |address, expected|
      it "with informal address: #{address}" do
        informal_addr = StreetAddress::US.parse_informal_address(address)
        expect(informal_addr.line2).to eq(expected[:line2])
      end
    end
  end

  describe '#to_s' do
    ADDRESSES.each_pair do |address, expected|
      it "with valid address: #{address}" do
        expected_result = expected[:to_s]
        expected_result ||= [expected[:line1], expected[:line2]].reject(&:empty?).join(', ')
        addr = StreetAddress::US.parse(address)
        expect(addr.to_s).to eq(expected_result)
      end
    end

    INTERSECTIONS.each_pair do |address, expected|
      it "with intersection: #{address}" do
        expected_result = expected[:to_s]
        expected_result ||= [expected[:line1], expected[:line2]].reject(&:empty?).join(', ')
        addr = StreetAddress::US.parse(address)
        expect(addr.to_s).to eq(expected_result)
      end
    end

    INFORMAL_ADDRESSES.each_pair do |address, expected|
      it "with informal address: #{address}" do
        expected_result = expected[:to_s]
        expected_result ||= [expected[:line1], expected[:line2]].reject(&:empty?).join(', ')
        informal_addr = StreetAddress::US.parse_informal_address(address)
        expect(informal_addr.to_s).to eq(expected_result)
      end
    end

    it 'with no line2' do
      address = '45 Quaker Ave, Ste 105'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s).to eq('45 Quaker Ave Ste 105')
    end

    it 'with valid addresses with zip_ext' do
      address = '7800 Mill Station Rd Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s).to eq('7800 Mill Station Rd, Sebastopol, CA 95472-1234')
    end

    it 'with option [:line1]' do
      address = '7800 Mill Station Rd Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s(:line1)).to eq('7800 Mill Station Rd')
    end

    it 'with option [:line2]' do
      address = '7800 Mill Station Rd Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s(:line2)).to eq('Sebastopol, CA 95472-1234')
    end

    it 'with option [:street_address_1]' do
      address = '7800 Mill Station Rd, Apt. 7B, Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s(:street_address_1)).to eq('7800 Mill Station Rd')
    end

    it 'with option [:street_address_2]' do
      address = '7800 Mill Station Rd, Apartment. 7B, Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s(:street_address_2)).to eq('Apt 7B')
    end

    it 'with option [:city_state_zip]' do
      address = '7800 Mill Station Rd Sebastopol CA 95472-1234'
      addr = StreetAddress::US.parse(address)
      expect(addr.to_s(:city_state_zip)).to eq('Sebastopol, CA 95472-1234')
    end

    it 'with option [:line1] and a PO Box' do
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

    it 'no postal code' do
      address = '7800 Mill Station Rd Sebastopol CA'
      addr = StreetAddress::US.parse(address)
      expect(addr.full_postal_code).to be_nil
    end
  end
end
