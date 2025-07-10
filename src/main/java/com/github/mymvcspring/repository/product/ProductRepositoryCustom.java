package com.github.mymvcspring.repository.product;

import com.github.mymvcspring.web.dto.PaginationDto;
import com.github.mymvcspring.web.dto.ProductStatisticsResponse;
import com.github.mymvcspring.web.dto.StatisticsResponse;
import com.github.mymvcspring.web.dto.product.ProductListRequest;
import com.github.mymvcspring.web.dto.product.ProductListResponse;

import java.util.List;

public interface ProductRepositoryCustom {
    ProductStatisticsResponse statisticsByMonthUser();

    ProductStatisticsResponse statisticsByMonthProductPrice();

    PaginationDto<ProductListResponse> findAllProductsBySpecName(long page, String specName);
    long countAllProductsBySpecName(String specName);

    PaginationDto<ProductListResponse> findAllByCategoryOrderBySort(ProductListRequest request);

    List<StatisticsResponse> statisticsByCategory();

    ProductStatisticsResponse statisticsByMonthRegistration();
}
