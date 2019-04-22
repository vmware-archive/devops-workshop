package io.pivotal;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.hateoas.ResourceSupport;
import org.springframework.hateoas.core.DefaultRelProvider;
import org.springframework.hateoas.hal.Jackson2HalModule;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.AbstractJackson2HttpMessageConverter;
import org.springframework.stereotype.Component;

@Component
// @see https://github.com/spring-cloud/spring-cloud-openfeign/issues/127
public class HalHttpMessageConverter extends AbstractJackson2HttpMessageConverter {

    @Autowired
    public HalHttpMessageConverter(MessageSource messageSource) {
        super(new ObjectMapper(), new MediaType("application", "hal+json", DEFAULT_CHARSET));
        objectMapper.registerModule(new Jackson2HalModule());
        objectMapper.setHandlerInstantiator(new Jackson2HalModule.HalHandlerInstantiator(new DefaultRelProvider(), null, new MessageSourceAccessor(messageSource)));
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    @Override
    protected boolean supports(Class<?> clazz) {
        return ResourceSupport.class.isAssignableFrom(clazz);
    }
}