# Graphite Notify

Send deployment events to graphite
More information about events https://code.launchpad.net/~lucio.torre/graphite/add-events/+merge/69142

## Installation

Add this to your deploy.rb file:

set :graphite_url, "your/graphite/event/url"
require "graphite-notify/capistrano"


## Requirements

graphite: http://readthedocs.org/docs/graphite

curl: http://curl.haxx.se/
