package io.pivotal;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.hateoas.Resources;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import io.pivotal.domain.City;

@FeignClient(name = "https://cloud-native-spring", fallbackFactory = CityClientFallbackFactory.class)
public interface CityClient {

  @GetMapping(value = "/cities")
  Resources<City> findAll(@RequestParam("page") int page, @RequestParam("size") int limit);

  @PostMapping(value = "/cities")
  City add(@RequestBody City company);

  @PutMapping(value = "/cities/{id}")
  City update(@PathVariable("id") Long id, @RequestBody City city);

  @DeleteMapping(value = "/cities/{id}")
  void delete(@PathVariable("id") Long id);
}