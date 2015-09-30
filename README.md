# Graphite Notify

Send capistrano deployment events to graphite

Warning: this gem works with capistrano 2.x, for capistrano 3.x see [this project](https://github.com/scottsuch/capistrano-graphite)

[![Build Status](https://travis-ci.org/hellvinz/graphite-notify.png)](https://travis-ci.org/hellvinz/graphite-notify)

More information about events https://code.launchpad.net/~lucio.torre/graphite/add-events/+merge/69142

## Installation

Add this to your deploy.rb file:

```
set :graphite_url, "your/graphite/event/url"
require "graphite-notify/capistrano"
```

## Requirements

graphite: http://readthedocs.org/docs/graphite

## Tricks

As it is a capistrano task you can call it directly:

```
cap graphite:notify_deploy
```
 
## License

graphite-notify is released under the [MIT License](http://www.opensource.org/licenses/MIT).
