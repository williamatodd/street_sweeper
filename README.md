[![Build Status](https://travis-ci.org/williamatodd/street_sweeper.svg?branch=master)](https://travis-ci.org/williamatodd/street_sweeper)
[![Gem Version](https://badge.fury.io/rb/street_sweeper.svg)](https://badge.fury.io/rb/street_sweeper)
# DESCRIPTION

Parses a string returning a normalized Address object. When the string is not an US address it returns nil.

This is a resurrected fork of [StreetSweeper::US](https://github.com/street-address-rb/street-address) which was itself a port of the perl module [Geo::StreetSweeper](https://github.com/timbunce/Geo-StreetAddress-US) originally written by Schuyler D. Erle.

## Installation

```shell
    gem install StreetSweeper
```

then in your code

```ruby
    require 'street_sweeper'
```

or from Gemfile

```ruby
    gem 'StreetSweeper', require: "street_sweeper"
```

## Basic Usage

```ruby
    require 'street_sweeper'

    address = StreetSweeper.parse("1600 Pennsylvania Ave, Washington, DC, 20500")
    address.street # Pennsylvania
    address.number # 1600
    address.postal_code # 20500
    address.city # Washington
    address.state # DC
    address.state_name # District of columbia
    address.street_type # Ave
    address.intersection? # false
    address.full_street_address # 1600 Pennsylvania Ave, Washington, DC 20500

    address = StreetSweeper.parse("1600 Pennsylvania Ave")
    address.street # Pennsylvania
    address.number # 1600
    address.state # nil

    address = StreetSweeper.parse("5904 Richmond Hwy Ste 340 Alexandria VA 22303-1864")
    address.street_address_1 # 5904 Richmond Hwy
    address.street_address_2 # Ste 340
    address.full_postal_code # 22303-1864
    address.postal_code_ext # 1846
    address.state_name # Virginia
    address.state_fips # 06

```
## Stricter Parsing

```ruby
    address = StreetSweeper.parse_address("1600 Pennsylvania Avenue")
    # nil - not enough information to be a full address

    address = StreetSweeper.parse_address("1600 Pennsylvania Ave, Washington, DC, 20500")
    # same results as above
```

## License
The [MIT License](http://opensource.org/licenses/MIT)

Copyright (c) 2007-2018 Contributors
