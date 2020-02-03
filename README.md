# README

## A scooter reporting its current location and battery life
Capability to report current location and battery life of a particular scooter is enabled by the `PUT   /scooters/:id(.:format) scooters#update` route.  Tests located in `spec/controllers/scooters_controller_spec.rb`

## A mobile app used by our operations team

# This app should be able to:
*Open a maintenance ticket + Open a maintenance ticket*
Capability to create a maintenance ticket is enabled by the `POST /scooters/:scooter_id/tickets` route. Tests located in `spec/controllers/tickets_controller_spec.rb`. This endpoint also puts the scooter in a `maintenance` state which is an inactive state.

*Request that a batch of scooters be unlocked all at once*
This functionality is enabled by the `PUT   /scooters/bulk_unlock` and the tests are located in `spec/controllers/scooters_controller_spec.rb`

_assumptions_
- only scooters that are in the `locked` state should be unlocked. otherwise the scooter is assumed to already be unlocked because it is in use by a customer (i.e. already in the 'unlocked' state) or it is being maintained (i.e. in a 'maintenance' state)

