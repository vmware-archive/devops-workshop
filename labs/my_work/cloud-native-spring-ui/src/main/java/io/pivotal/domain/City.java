package io.pivotal.domain;

import java.io.Serializable;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class City implements Serializable {
    private static final long serialVersionUID = 1L;

    private long id;
    @NotNull
    private String name;
    @NotNull
    private String county;
    @NotNull
    @Size(max = 2)
    private String stateCode;
    @NotNull
    @Size(max = 15)
    private String postalCode;
    private String latitude;
    private String longitude;

}