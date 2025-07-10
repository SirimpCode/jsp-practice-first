package com.github.mymvcspring.web.dto.product;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ProductListRequest {
    private long page;
    private long size;
    private Category category;
    private Sort sort;

    public static ProductListRequest of(long page, long size, String category, String sort) {
        ProductListRequest request = new ProductListRequest();
        try{
            request.category =  Category.valueOf(category.toUpperCase());
        }catch (IllegalArgumentException | NullPointerException e ){
            request.category = Category.ALL;
        }
        try {
            request.sort = Sort.valueOf(sort.toUpperCase());
        }catch (IllegalArgumentException | NullPointerException e ){
            request.sort = Sort.NEWEST;
        }
        request.page = page-1; // 페이지는 0부터 시작하므로 -1
        request.size = size;

        return request;
    }
    @AllArgsConstructor
    @Getter
    public enum Category {
        ELECTRONIC("전자제품"), CLOTHING("의류"), BOOK("도서"), HIT("1"), ALL("전체");
        private final String value;


    }
    @AllArgsConstructor
    @Getter
    public enum Sort {
        PRICE_ASC("가격 낮은 순"), PRICE_DESC("가격 높은 순"), NEWEST("최신순"), OLDEST("오래된 순");
        private final String value;
    }

}
