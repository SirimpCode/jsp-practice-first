package com.github.mymvcspring.service;

import com.github.mymvcspring.repository.Image;
import com.github.mymvcspring.repository.ImageRepository;
import com.github.mymvcspring.repository.product.*;
import com.github.mymvcspring.repository.user.MyUser;
import com.github.mymvcspring.web.dto.ProductStatisticsResponse;
import com.github.mymvcspring.web.dto.StatisticsResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ViewService {
    private final ImageRepository imageRepository;
    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final ProductSpecRepository productSpecRepository;

    public List<Image> getAllImages() {
        return imageRepository.findAll();
    }

    public boolean loginValidation(String userId, MyUser loginUser) {
        return loginUser != null && loginUser.getUserId().equals(userId);
        // 결제 확인 로직을 여기에 추가
        // 예: 결제 상태 업데이트, 알림 전송 등
    }

    public long getProductCountBySpec(long specId) {
        ProductSpec productSpec = ProductSpec.onlyId(specId);
        return productRepository.countByProductSpec(productSpec);
    }
    @Transactional(readOnly = true)
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<ProductSpec> getAllProductSpecs() {
        return productSpecRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<StatisticsResponse> obtainingStatistics() {
        List<StatisticsResponse> statisticsResponses = productRepository.statisticsByCategory();



        long totalCount  = statisticsResponses.stream()
                .mapToLong(StatisticsResponse::getCount)
                .sum();
        statisticsResponses.forEach(statisticsResponse -> {
            statisticsResponse.settingValue(totalCount);
        });

        return statisticsResponses;
    }
    @Transactional(readOnly = true)
    public List<ProductStatisticsResponse> obtainingProductStatistics() {
        ProductStatisticsResponse monthRegistration = productRepository.statisticsByMonthRegistration();
        ProductStatisticsResponse monthUser = productRepository.statisticsByMonthUser();
        ProductStatisticsResponse monthProductPrice = productRepository.statisticsByMonthProductPrice();
        return List.of(
                monthRegistration,
                monthUser,
                monthProductPrice
        );
    }
}
