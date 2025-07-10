package com.github.mymvcspring.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Value("${file.upload.directory}")
    private String uploadPath;
    @Override
    public void addResourceHandlers(org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry registry) {
        // 외부 업로드 폴더 매핑
        registry.addResourceHandler("/uploads/**")//예 /uploads/image.jpg 즉 /uploads/로 시작하는 URL 요청을 처리
                .addResourceLocations("file:///"+uploadPath) // file:///로 시작하는 외부 파일 시스템 경로를 지정
                .setCachePeriod(3600);

        // 기존 static 리소스 매핑
        registry.addResourceHandler("/**")// 그외에 모든 URL 요청을 처리
                .addResourceLocations("classpath:/static/")
                .setCachePeriod(3600);
    }
}