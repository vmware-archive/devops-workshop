#!/bin/sh

# Creates services

cf cs p-config-server standard config-server -c ../../04/cloud-native-spring/config-server.json
cf cs p-service-registry standard service-registry
cf cs p-circuit-breaker-dashboard circuit-breaker
