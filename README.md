# README

## How to run the app
use `sh bin/dev-up` to build and run the application using docker.
This will:
1. start a postgres server with the postgis extension
2. start a webserver
3. create a database
4. seed your database with a few scooters

after running the command you can test some of the functionality via the `curl` command. examples:

find active scooters within a 5 mile radius of a given lon + lat: `curl "localhost:3000/scooters/active?lon=-122.4&lat=37&radius=5"`

create a maintenance ticket: `curl -X POST "localhost:3000/scooters/1/tickets?description=fix"`

data feed of all scooters and their state transitions: `curl "localhost:3000/scooters/"`

unlock a list of scooters: `curl -X PUT "localhost:3000/scooters/bulk_unlock?ids=1,2,4"`

update a scooter location and set battery to 5%: `curl -X PUT "localhost:3000/scooters/1?lon=122&lat=34&battery=5"`


## A scooter reporting its current location and battery life
Capability to report current location and battery life of a particular scooter is enabled by the `PUT   /scooters/:id(.:format) scooters#update` route.  Tests located in `spec/controllers/scooters_controller_spec.rb`

ex curl command: `curl -X PUT "localhost:3000/scooters/bulk_unlock?ids=1,2,4"`

## A mobile app used by our operations team

### This app should be able to:
*Open a maintenance ticket + Mark a scooter as inactive and being picked up for maintenance*
ex curl command: `curl -X POST "localhost:3000/scooters/1/tickets?description=fix"`

Capability to create a maintenance ticket is enabled by the `POST /scooters/:scooter_id/tickets` route. Tests located in `spec/controllers/tickets_controller_spec.rb`. This endpoint also puts the scooter in a `maintenance` state which is an inactive state.

*Request that a batch of scooters be unlocked all at once*

This functionality is enabled by the `PUT   /scooters/bulk_unlock` and the tests are located in `spec/controllers/scooters_controller_spec.rb`
ex curl command: `curl -X PUT "localhost:3000/scooters/bulk_unlock?ids=1,2,4"`

_assumptions_
- only scooters that are in the `locked` state should be unlocked. otherwise the scooter is assumed to already be unlocked because it is in use by a customer (i.e. already in the 'unlocked' state) or it is being maintained (i.e. in a 'maintenance' state)

## A mobile app used by customers
*This app should be able to show where active scooters are on a map within a given radius from the user's current lat/long location.*

This is implemented by the `ScootersController#active` action. Tests are located in the `spec/controllers/scooters_controller_spec.rb`.
ex curl command: `curl "localhost:3000/scooters/active?lon=-122.4&lat=37&radius=5"`

_assumptions_
- only scooters in a 'locked' state should be considered active since they are otherwise in use by other customers or being maintained.

*Active scooters are defined as those having >= 30% battery life and not picked up for maintenance.*

Tests for this are located in the `spec/controllers/scooters_controller_spec.rb`

## City governments requesting a historical data feed
*This feed should conform to a JSON schema spec.*

This data feed is generated using the aasm state machine gem and the creation of a `transition` record for every single state transition in the `after_all_transitions` callback on the `Scooter` model. The `transition` records contain the location + battery data of the scooter before and after each transition. It also includes the state that the scooter transitioned from and to and records the event that triggered the transition.

ex curl command: `curl "localhost:3000/scooters/"`

This state transition tracking allows us to understand the lifecycle of a scooter at any given point in time. We can build powerful maps and debugging tools on top of this `transitions` table.

```
The feed should any state transition through which the scooter has run, such as:
battery life being updated
location being updated
maintenance state changes
```
We get all of this functionality through the transitions table and the use of a state machine in our Scooter model.