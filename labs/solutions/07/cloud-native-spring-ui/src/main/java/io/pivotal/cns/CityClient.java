package io.pivotal.cns;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.hateoas.Resources;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import io.pivotal.cns.domain.City;

@FeignClient(name = "https://spring-cloud-gateway", fallbackFactory = CityClientFallbackFactory.class)
public interface CityClient {

  @GetMapping(value = "/api/cities")
  Resources<City> findAll(@RequestParam("page") int page, @RequestParam("size") int limit);

  @PostMapping(value = "/api/cities")
  City add(@RequestBody City company);

  @PutMapping(value = "/api/cities/{id}")
  City update(@PathVariable("id") Long id, @RequestBody City city);

  @DeleteMapping(value = "/api/cities/{id}")
  void delete(@PathVariable("id") Long id);
}