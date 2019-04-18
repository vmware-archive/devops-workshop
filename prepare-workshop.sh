#!/bin/bash

cd labs/my_work/cloud-native-spring
./gradlew clean build
cd ../cloud-native-spring-ui
./gradlew clean build
cd ../../solutions/01/cloud-native-spring
./gradlew clean build
cd ../../02/cloud-native-spring
./gradlew clean build
cd ../../03/cloud-native-spring
./gradlew clean build
cd ../../04/cloud-native-spring
./gradlew clean build
cd ../../05/cloud-native-spring
./gradlew clean build
cd ../cloud-native-spring-ui
./gradlew clean build -x test
cd ../../06/cloud-native-spring-ui
./gradlew clean build -x test