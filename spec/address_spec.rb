# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StreetSweeper::Address do
  NORMAL_ADDRESSES = {
    '1005 Gravenstein Hwy 95472' => {
      line1: '1005 Gravenstein Hwy',
      line2: '95472',
      street_address_1: '1005 Gravenstein Hwy',
      street_address_2: '',
      full_street_address: '1005 Gravenstein Hwy, 95472',
      intersection?: false
    },
    '1005 Gravenstein Hwy, 95472' => {
      line1: '1005 Gravenstein Hwy',
      line2: '95472',
      street_address_1: '1005 Gravenstein Hwy',
      street_address_2: '',
      full_street_address: '1005 Gravenstein Hwy, 95472',
      intersection?: false
    },
    '1005 Gravenstein Hwy N, 95472' => {
      line1: '1005 Gravenstein Hwy N',
      line2: '95472',
      street_address_1: '1005 Gravenstein Hwy N',
      street_address_2: '',
      full_street_address: '1005 Gravenstein Hwy N, 95472',
      intersection?: false
    },
    '1005 Gravenstein Highway North, 95472' => {
      line1: '1005 Gravenstein Hwy N',
      line2: '95472',
      street_address_1: '1005 Gravenstein Hwy N',
      street_address_2: '',
      full_street_address: '1005 Gravenstein Hwy N, 95472',
      intersection?: false
    },
    '1005 N Gravenstein Highway, Sebastopol, CA' => {
      line1: '1005 N Gravenstein Hwy',
      line2: 'Sebastopol, CA',
      street_address_1: '1005 N Gravenstein Hwy',
      street_address_2: '',
      full_street_address: '1005 N Gravenstein Hwy, Sebastopol, CA',
      intersection?: false
    },
    '1005 N Gravenstein Highway, Suite 500, Sebastopol, CA' => {
      line1: '1005 N Gravenstein Hwy Ste 500',
      line2: 'Sebastopol, CA',
      street_address_1: '1005 N Gravenstein Hwy',
      street_address_2: 'Ste 500',
      full_street_address: '1005 N Gravenstein Hwy Ste 500, Sebastopol, CA',
      intersection?: false
    },
    '1005 N Gravenstein Hwy Suite 500 Sebastopol, CA' => {
      line1: '1005 N Gravenstein Hwy Ste 500',
      line2: 'Sebastopol, CA',
      street_address_1: '1005 N Gravenstein Hwy',
      street_address_2: 'Ste 500',
      full_street_address: '1005 N Gravenstein Hwy Ste 500, Sebastopol, CA',
      intersection?: false
    },
    '1005 N Gravenstein Highway, Sebastopol, CA, 95472' => {
      line1: '1005 N Gravenstein Hwy',
      line2: 'Sebastopol, CA 95472',
      street_address_1: '1005 N Gravenstein Hwy',
      street_address_2: '',
      full_street_address: '1005 N Gravenstein Hwy, Sebastopol, CA 95472',
      intersection?: false
    },
    '1005 N Gravenstein Highway Sebastopol CA 95472' => {
      line1: '1005 N Gravenstein Hwy',
      line2: 'Sebastopol, CA 95472',
      street_address_1: '1005 N Gravenstein Hwy',
      street_address_2: '',
      full_street_address: '1005 N Gravenstein Hwy, Sebastopol, CA 95472',
      intersection?: false
    },
    '1005 Gravenstein Hwy N Sebastopol CA' => {
      line1: '1005 Gravenstein Hwy N',
      line2: 'Sebastopol, CA',
      street_address_1: '1005 Gravenstein Hwy N',
      street_address_2: '',
      full_street_address: '1005 Gravenstein Hwy N, Sebastopol, CA',
      intersection?: false
    },
    '1005 Gravenstein Hwy N, Sebastopol CA' => {
      line1: '1005 Gravenstein Hwy N',
      line2: 'Sebastopol, CA',
      street_address_1: '1005 Gravenstein Hwy N',
      street_address_2: '',
      full_street_address: '1005 Gravenstein Hwy N, Sebastopol, CA',
      intersection?: false
    },
    '1005 Gravenstein Hwy, N Sebastopol CA' => {
      line1: '1005 Gravenstein Hwy',
      line2: 'North Sebastopol, CA',
      street_address_1: '1005 Gravenstein Hwy',
      street_address_2: '',
      full_street_address: '1005 Gravenstein Hwy, North Sebastopol, CA',
      intersection?: false
    },
    '1005 Gravenstein Hwy Sebastopol CA' => {
      line1: '1005 Gravenstein Hwy',
      line2: 'Sebastopol, CA',
      street_address_1: '1005 Gravenstein Hwy',
      street_address_2: '',
      full_street_address: '1005 Gravenstein Hwy, Sebastopol, CA',
      intersection?: false
    },
    '115 Broadway San Francisco CA' => {
      line1: '115 Broadway',
      line2: 'San Francisco, CA',
      street_address_1: '115 Broadway',
      street_address_2: '',
      full_street_address: '115 Broadway, San Francisco, CA',
      intersection?: false
    },
    '7800 Mill Station Rd, Sebastopol, CA 95472' => {
      line1: '7800 Mill Station Rd',
      line2: 'Sebastopol, CA 95472',
      street_address_1: '7800 Mill Station Rd',
      street_address_2: '',
      full_street_address: '7800 Mill Station Rd, Sebastopol, CA 95472',
      intersection?: false
    },
    '7800 Mill Station Rd Sebastopol CA 95472' => {
      line1: '7800 Mill Station Rd',
      line2: 'Sebastopol, CA 95472',
      street_address_1: '7800 Mill Station Rd',
      street_address_2: '',
      full_street_address: '7800 Mill Station Rd, Sebastopol, CA 95472',
      intersection?: false
    },
    '1005 State Highway 116 Sebastopol CA 95472' => {
      line1: '1005 State Highway 116',
      line2: 'Sebastopol, CA 95472',
      street_address_1: '1005 State Highway 116',
      street_address_2: '',
      full_street_address: '1005 State Highway 116, Sebastopol, CA 95472',
      intersection?: false
    },
    '1600 Pennsylvania Ave. NW Washington DC' => {
      line1: '1600 Pennsylvania Ave NW',
      line2: 'Washington, DC',
      street_address_1: '1600 Pennsylvania Ave NW',
      street_address_2: '',
      full_street_address: '1600 Pennsylvania Ave NW, Washington, DC',
      intersection?: false
    },
    '1600 Pennsylvania Avenue NW Washington DC' => {
      line1: '1600 Pennsylvania Ave NW',
      line2: 'Washington, DC',
      street_address_1: '1600 Pennsylvania Ave NW',
      street_address_2: '',
      full_street_address: '1600 Pennsylvania Ave NW, Washington, DC',
      intersection?: false
    },
    '48S 400E, Salt Lake City UT' => {
      line1: '48 S 400 E',
      line2: 'Salt Lake City, UT',
      street_address_1: '48 S 400 E',
      street_address_2: '',
      full_street_address: '48 S 400 E, Salt Lake City, UT',
      intersection?: false
    },
    '550 S 400 E #3206, Salt Lake City UT 84111' => {
      line1: '550 S 400 E # 3206',
      line2: 'Salt Lake City, UT 84111',
      street_address_1: '550 S 400 E',
      street_address_2: '# 3206',
      full_street_address: '550 S 400 E # 3206, Salt Lake City, UT 84111',
      intersection?: false
    },
    '6641 N 2200 W Apt D304 Park City, UT 84098' => {
      line1: '6641 N 2200 W Apt D304',
      line2: 'Park City, UT 84098',
      street_address_1: '6641 N 2200 W',
      street_address_2: 'Apt D304',
      full_street_address: '6641 N 2200 W Apt D304, Park City, UT 84098',
      intersection?: false
    },
    '100 South St, Philadelphia, PA' => {
      line1: '100 South St',
      line2: 'Philadelphia, PA',
      street_address_1: '100 South St',
      street_address_2: '',
      full_street_address: '100 South St, Philadelphia, PA',
      intersection?: false
    },
    '100 S.E. Washington Ave, Minneapolis, MN' => {
      line1: '100 SE Washington Ave',
      line2: 'Minneapolis, MN',
      street_address_1: '100 SE Washington Ave',
      street_address_2: '',
      full_street_address: '100 SE Washington Ave, Minneapolis, MN',
      intersection?: false
    },
    '3813 1/2 Some Road, Los Angeles, CA' => {
      line1: '3813 Some Rd',
      line2: 'Los Angeles, CA',
      street_address_1: '3813 Some Rd',
      street_address_2: '',
      full_street_address: '3813 Some Rd, Los Angeles, CA',
      intersection?: false
    },
    '1 First St, e San Jose CA' => {
      line1: '1 1st St',
      line2: 'East San Jose, CA',
      street_address_1: '1 1st St',
      street_address_2: '',
      full_street_address: '1 1st St, East San Jose, CA',
      intersection?: false
    },
    'lt42 99 Some Road, Some City LA' => {
      line1: '99 Some Rd Lot 42',
      line2: 'Some City, LA',
      street_address_1: '99 Some Rd',
      street_address_2: 'Lot 42',
      full_street_address: '99 Some Rd Lot 42, Some City, LA',
      intersection?: false
    },
    '36401 County Road 43, Eaton, CO 80615' => {
      line1: '36401 County Road 43',
      line2: 'Eaton, CO 80615',
      street_address_1: '36401 County Road 43',
      street_address_2: '',
      full_street_address: '36401 County Road 43, Eaton, CO 80615',
      intersection?: false
    },
    '1234 COUNTY HWY 60E, Town, CO 12345' => {
      line1: '1234 County Hwy 60 E',
      line2: 'Town, CO 12345',
      street_address_1: '1234 County Hwy 60 E',
      street_address_2: '',
      full_street_address: '1234 County Hwy 60 E, Town, CO 12345',
      intersection?: false
    },
    "'45 Quaker Ave, Ste 105'" => {
      line1: '45 Quaker Ave Ste 105',
      line2: '',
      street_address_1: '45 Quaker Ave',
      street_address_2: 'Ste 105',
      full_street_address: '45 Quaker Ave Ste 105',
      intersection?: false
    },
    '2730 S Veitch St Apt 207, Arlington, VA 22206' => {
      line1: '2730 S Veitch St Apt 207',
      line2: 'Arlington, VA 22206',
      street_address_1: '2730 S Veitch St',
      street_address_2: 'Apt 207',
      full_street_address: '2730 S Veitch St Apt 207, Arlington, VA 22206',
      intersection?: false
    },
    '2730 S Veitch St #207, Arlington, VA 22206' => {
      line1: '2730 S Veitch St # 207',
      line2: 'Arlington, VA 22206',
      street_address_1: '2730 S Veitch St',
      street_address_2: '# 207',
      full_street_address: '2730 S Veitch St # 207, Arlington, VA 22206',
      intersection?: false
    },
    '44 Canal Center Plaza Suite 500, Alexandria, VA 22314' => {
      line1: '44 Canal Center Plz Ste 500',
      line2: 'Alexandria, VA 22314',
      street_address_1: '44 Canal Center Plz',
      street_address_2: 'Ste 500',
      full_street_address: '44 Canal Center Plz Ste 500, Alexandria, VA 22314',
      intersection?: false
    },
    'One East 161st Street, Bronx, NY 10451' => {
      line1: 'One East 161st St',
      line2: 'Bronx, NY 10451',
      street_address_1: 'One East 161st St',
      street_address_2: '',
      full_street_address: 'One East 161st St, Bronx, NY 10451',
      intersection?: false
    },
    'One East 161st Street Suite 10, Bronx, NY 10451' => {
      line1: 'One East 161st St Ste 10',
      line2: 'Bronx, NY 10451',
      street_address_1: 'One East 161st St',
      street_address_2: 'Ste 10',
      full_street_address: 'One East 161st St Ste 10, Bronx, NY 10451',
      intersection?: false
    },
    'P.O. Box 280568 Queens Village, New York 11428' => {
      line1: 'PO Box 280568',
      line2: 'Queens Village, NY 11428',
      street_address_1: 'PO Box 280568',
      street_address_2: '',
      full_street_address: 'PO Box 280568, Queens Village, NY 11428',
      intersection?: false
    },
    'PO BOX 280568 Queens Village, New York 11428' => {
      line1: 'PO Box 280568',
      line2: 'Queens Village, NY 11428',
      street_address_1: 'PO Box 280568',
      street_address_2: '',
      full_street_address: 'PO Box 280568, Queens Village, NY 11428',
      intersection?: false
    },
    'PO 280568 Queens Village, New York 11428' => {
      line1: 'PO 280568',
      line2: 'Queens Village, NY 11428',
      street_address_1: 'PO 280568',
      street_address_2: '',
      full_street_address: 'PO 280568, Queens Village, NY 11428',
      intersection?: false
    },
    'Two Pennsylvania Plaza New York, NY 10121-0091' => {
      line1: 'Two Pennsylvania Plz',
      line2: 'New York, NY 10121-0091',
      street_address_1: 'Two Pennsylvania Plz',
      street_address_2: '',
      full_street_address: 'Two Pennsylvania Plz, New York, NY 10121-0091',
      intersection?: false
    },
    '1400 CONNECTICUT AVE NW, WASHINGTON, DC 20036' => {
      line1: '1400 Connecticut Ave NW',
      line2: 'Washington, DC 20036',
      street_address_1: '1400 Connecticut Ave NW',
      street_address_2: '',
      full_street_address: '1400 Connecticut Ave NW, Washington, DC 20036',
      intersection?: false
    }
  }.freeze

  INTERSECTIONS = {
    'Mission & Valencia San Francisco CA' => {
      line1: 'Mission and Valencia',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission and Valencia',
      street_address_2: '',
      full_street_address: 'Mission and Valencia, San Francisco, CA',
      intersection?: true
    },
    'Mission & Valencia, San Francisco CA' => {
      line1: 'Mission and Valencia',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission and Valencia',
      street_address_2: '',
      full_street_address: 'Mission and Valencia, San Francisco, CA',
      intersection?: true
    },
    'Mission St and Valencia St San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission St and Valencia St',
      street_address_2: '',
      full_street_address: 'Mission St and Valencia St, San Francisco, CA',
      intersection?: true
    },
    'Hollywood Blvd and Vine St Los Angeles, CA' => {
      line1: 'Hollywood Blvd and Vine St',
      line2: 'Los Angeles, CA',
      street_address_1: 'Hollywood Blvd and Vine St',
      street_address_2: '',
      full_street_address: 'Hollywood Blvd and Vine St, Los Angeles, CA',
      intersection?: true
    },
    'Mission St & Valencia St San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission St and Valencia St',
      street_address_2: '',
      full_street_address: 'Mission St and Valencia St, San Francisco, CA',
      intersection?: true
    },
    'Mission and Valencia Sts San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission St and Valencia St',
      street_address_2: '',
      full_street_address: 'Mission St and Valencia St, San Francisco, CA',
      intersection?: true
    },
    'Mission & Valencia Sts. San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission St and Valencia St',
      street_address_2: '',
      full_street_address: 'Mission St and Valencia St, San Francisco, CA',
      intersection?: true
    },
    'Mission & Valencia Streets San Francisco CA' => {
      line1: 'Mission St and Valencia St',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission St and Valencia St',
      street_address_2: '',
      full_street_address: 'Mission St and Valencia St, San Francisco, CA',
      intersection?: true
    },
    'Mission Avenue and Valencia Street San Francisco CA' => {
      line1: 'Mission Ave and Valencia St',
      line2: 'San Francisco, CA',
      street_address_1: 'Mission Ave and Valencia St',
      street_address_2: '',
      full_street_address: 'Mission Ave and Valencia St, San Francisco, CA',
      intersection?: true
    }
  }.freeze

  INFORMAL_ADDRESSES = {
    '#42 233 S Wacker Dr 60606' => {
      line1: '233 S Wacker Dr # 42',
      line2: '60606',
      street_address_1: '233 S Wacker Dr',
      street_address_2: '# 42',
      full_street_address: '233 S Wacker Dr # 42, 60606',
      intersection?: false
    },
    'Apt. 42, 233 S Wacker Dr 60606' => {
      line1: '233 S Wacker Dr Apt 42',
      line2: '60606',
      street_address_1: '233 S Wacker Dr',
      street_address_2: 'Apt 42',
      full_street_address: '233 S Wacker Dr Apt 42, 60606',
      intersection?: false
    },
    '2730 S Veitch St #207' => {
      line1: '2730 S Veitch St # 207',
      line2: '',
      street_address_1: '2730 S Veitch St',
      street_address_2: '# 207',
      full_street_address: '2730 S Veitch St # 207',
      intersection?: false
    },
    '321 S. Washington' => {
      line1: '321 S Washington',
      line2: '',
      street_address_1: '321 S Washington',
      street_address_2: '',
      full_street_address: '321 S Washington',
      intersection?: false
    },
    '233 S Wacker Dr lobby 60606' => {
      line1: '233 S Wacker Dr Lbby',
      line2: '60606',
      street_address_1: '233 S Wacker Dr',
      street_address_2: 'Lbby',
      full_street_address: '233 S Wacker Dr Lbby, 60606',
      intersection?: false
    }
  }.freeze

  METHODS = %w[line1 line2 street_address_1 street_address_2 full_street_address intersection?].freeze\

  ADDRS = NORMAL_ADDRESSES.merge(INFORMAL_ADDRESSES)
  ALL = ADDRS.merge(INTERSECTIONS)

  ALL.each_pair do |address, expected|
    context address.to_s do
      METHODS.each do |method_name|
        next if expected[method_name.to_sym].to_s == ''
        it "#{method_name}: #{expected[method_name.to_sym]}" do
          compare_expected_to_actual(expected, address, method_name)
        end
      end
    end
  end

  describe '#full_postal_code' do
    it 'without postal code' do
      addr = StreetSweeper.parse('7800 Mill Station Rd Sebastopol CA')
      expect(addr.full_postal_code).to be_nil
    end

    it 'with only the first five digits' do
      addr = StreetSweeper.parse('7800 Mill Station Rd Sebastopol CA 95472')
      expect(addr.full_postal_code).to eq('95472')
    end

    it 'with valid zip plus 4 with dash' do
      addr = StreetSweeper.parse('2730 S Veitch St, Arlington, VA 22206-3333')
      expect(addr.full_postal_code).to eq('22206-3333')
    end

    it 'with valid zip plus 4 without dash' do
      addr = StreetSweeper.parse('2730 S Veitch St, Arlington, VA 222064444')
      expect(addr.full_postal_code).to eq('22206-4444')
    end
  end

  describe '#postal_code_ext' do
    it 'without postal code' do
      addr = StreetSweeper.parse('7800 Mill Station Rd Sebastopol CA')
      expect(addr.full_postal_code).to be_nil
    end

    it 'with valid zip plus 4 with dash' do
      addr = StreetSweeper.parse('2730 S Veitch St, Arlington, VA 22206-3333')
      expect(addr.postal_code_ext).to eq('3333')
    end

    it 'with valid zip plus 4 without dash' do
      addr = StreetSweeper.parse('2730 S Veitch St, Arlington, VA 222064444')
      expect(addr.postal_code_ext).to eq('4444')
    end
  end

  describe '#state_name' do
    it 'with a vaild address' do
      addr = StreetSweeper.parse('7800 Mill Station Rd Sebastopol CA 95472')
      expect(addr.state_name).to eq('California')
    end

    it 'with an invaild address' do
      addr = StreetSweeper.parse('7800 Mill Station Rd Sebastopol 95472')
      expect(addr.state_name).to be_nil
    end
  end

  describe '#state_fips' do
    it 'with a vaild address' do
      addr = StreetSweeper.parse('7800 Mill Station Rd Sebastopol CA 95472')
      expect(addr.state_fips).to eq('06')
    end

    it 'with an invaild address' do
      addr = StreetSweeper.parse('7800 Mill Station Rd Sebastopol 95472')
      expect(addr.state_fips).to be_nil
    end
  end

  def compare_expected_to_actual(expected, address, method_name)
    addr = StreetSweeper.parse(address)
    expect(addr.send(method_name)).to eq(expected[method_name.to_sym])
  end
end
