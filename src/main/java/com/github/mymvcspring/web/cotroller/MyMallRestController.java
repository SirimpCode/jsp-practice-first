package com.github.mymvcspring.web.cotroller;

import com.github.mymvcspring.service.product.ProductService;
import com.github.mymvcspring.web.dto.CustomResponse;
import com.github.mymvcspring.web.dto.PaginationDto;
import com.github.mymvcspring.web.dto.member.MemberListResponse;
import com.github.mymvcspring.web.dto.product.ProductListRequest;
import com.github.mymvcspring.web.dto.product.ProductListResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/mall")
@RequiredArgsConstructor
public class MyMallRestController {
    private final ProductService  productService;

    @GetMapping
    public CustomResponse<PaginationDto<ProductListResponse>> productList(@RequestParam(defaultValue = "1") long page,
                                                                          @RequestParam(defaultValue = "8") long size,
                                                                          @RequestParam(defaultValue = "hit") String category,
                                                                          @RequestParam(defaultValue = "newest") String sort){

        ProductListRequest request = ProductListRequest.of(page, size, category, sort);

        return productService.getProductListByRequest(request)
                .filter(list -> !list.getItems().isEmpty())
                .map(productList -> CustomResponse.ofOk("상품 목록 조회 성공", productList))
                .orElseGet(() -> CustomResponse.emptyDataOk("상품 목록이 없습니다."));

//        return productService.getHitProductList(page-1, specName)
//                .filter(list -> !list.getItems().isEmpty())
//                .map(productList -> CustomResponse.ofOk("상품 목록 조회 성공", productList))
//                .orElseGet(() -> CustomResponse.emptyDataOk("상품 목록이 없습니다."));
    }

}
