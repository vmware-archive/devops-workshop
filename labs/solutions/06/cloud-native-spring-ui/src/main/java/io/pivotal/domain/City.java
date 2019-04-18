package io.pivotal.domain;

import java.io.Serializable;

import lombok.Data;

@Data
public class City implements Serializable {
    private static final long serialVersionUID = 1L;

    private long id;
    private String name;
    private String county;
    private String stateCode;
    private String postalCode;
    private String latitude;
    private String longitude;

}