package com.github.mymvcspring.web.dto.sms;

import lombok.Getter;

import java.time.LocalDateTime;
@Getter
public class MessageRequest {
    private LocalDateTime reservedDateTime;
    private String message;
    private String phoneNumber;
    // getter, setter

}
