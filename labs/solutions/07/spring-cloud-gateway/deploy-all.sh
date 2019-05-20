#!/bin/sh

# Builds, pushes (with no start option), binds services, then starts all apps and gateway

cd ../../05/cloud-native-spring
./gradlew clean build
cf push --no-start
cf bs cloud-native-spring config-server
cf bs cloud-native-spring service-registry
cf start cloud-native-spring

cd ../../07/spring-cloud-gateway
cf push --no-start
./gradlew clean build
cf bs spring-cloud-gateway config-server
cf bs spring-cloud-gateway service-registry
cf start spring-cloud-gateway

cd ../../07/cloud-native-spring-ui
cf push --no-start
./gradlew clean build
cf bs cloud-native-spring-ui service-registry
cf bs cloud-native-spring-ui circuit-breaker
cf start cloud-native-spring-ui