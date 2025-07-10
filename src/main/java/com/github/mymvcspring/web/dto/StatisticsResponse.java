package com.github.mymvcspring.web.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;

@Getter
//@AllArgsConstructor(staticName = "of")
public class StatisticsResponse {
    private String name;
    //제이슨 직렬화시 키값 설정
    @JsonProperty(value = "y")
    private double value;

    //역직렬화만 가능
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private long count;

    public void settingValue(long totalCount) {
        if (totalCount == 0) {
            this.value = 0;
        } else {
            this.value = ((double) this.count) / totalCount;
        }
    }
}
