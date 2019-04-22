package io.pivotal;

import java.util.Collections;

import org.springframework.hateoas.Resources;
import org.springframework.stereotype.Component;

import feign.hystrix.FallbackFactory;
import io.pivotal.domain.City;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
class CityClientFallbackFactory implements FallbackFactory<CityClient> {

    @Override
    public CityClient create(final Throwable t) {
        return new CityClient() {
            @Override
            public Resources<City> findAll(int page, int limit) {
                log.warn("Fallback triggered by {} due to {}", t.getClass().getName(), t.getMessage());
                return new Resources<City>(Collections.emptyList());
            }

            @Override
            public City add(City company) {
                return null;
            }

            @Override
            public City update(Long id, City company) {
                return null;
            }

            @Override
            public void delete(Long id) {}
        };
    }
}