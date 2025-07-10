package com.github.mymvcspring.web.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.List;

@Getter
@AllArgsConstructor(staticName = "of")
public class ProductStatisticsResponse {
    private String name;

//    @JsonIgnore@AllArgsConstructor(staticName = "of")

    @JsonProperty(value = "data")
    private List<Long> count;
}
