package io.pivotal;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.hateoas.Resources;
import io.pivotal.domain.City;


@FeignClient(name = "https://cloud-native-spring", fallbackFactory = CityClientFallbackFactory.class)
public interface CityClient {

  @GetMapping(value="/cities", consumes="application/hal+json")
  Resources<City> getCities();
}