package io.pivotal;

import feign.hystrix.FallbackFactory;
import java.util.Collections;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.hateoas.Resources;
import io.pivotal.domain.City;

@Slf4j
@Component
class CityClientFallbackFactory implements FallbackFactory<CityClient> {

    @Override
    public CityClient create(final Throwable t) {
        return new CityClient() {
            @Override
            public Resources<City> getCities() {
                log.info("Fallback triggered by {} due to {}", t.getClass().getName(), t.getMessage());
                return new Resources<City>(Collections.emptyList());
            }
        };
    }
}