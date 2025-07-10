package com.github.mymvcspring.web.cotroller;

import com.github.mymvcspring.service.MessageService;
import com.github.mymvcspring.web.dto.sms.MessageRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/message")
@RequiredArgsConstructor
public class MessageRestController {
    private final MessageService messageService;
    @PostMapping("/send")
    public LocalDateTime sendMessage(@RequestBody MessageRequest messageRequest) {
        // Implement SMS sending logic here
        messageService.sendMessage(messageRequest);
        return messageRequest.getReservedDateTime();
    }
}
