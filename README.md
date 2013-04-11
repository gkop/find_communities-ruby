# find_communities-ruby

Ruby implementation of [Louvain community detection method](https://sites.google.com/site/findcommunities/).

## Installation

Add this line to your application's Gemfile:

    gem 'find_communities-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install find_communities-ruby

## Usage

    $ community -l -1 karate.bin
    0 2
    1 0
    2 0
    3 0
    4 0
    5 1
    6 3
    7 3
    8 0
    9 5
    10 0
    11 1
    12 0
    13 0
    14 0
    15 2
    16 2
    17 3
    18 0
    19 2
    20 0
    21 2
    22 0
    23 2
    24 2
    25 4
    26 4
    27 2
    28 2
    29 4
    30 2
    31 5
    32 4
    33 2
    0 0
    1 1
    2 3
    3 1
    4 2
    5 3
    0 0
    1 1
    2 2
    3 3
    0.426969

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## CI

[![Build Status](https://secure.travis-ci.org/gkop/find_communities-ruby.png?branch=master)](http://travis-ci.org/gkop/find_communities-ruby)

## License

Released under the [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0-standalone.html).
