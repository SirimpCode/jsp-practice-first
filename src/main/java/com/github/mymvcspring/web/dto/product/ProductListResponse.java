package com.github.mymvcspring.web.dto.product;

import lombok.Getter;

@Getter
public class ProductListResponse {
    private long productId;
    private String productName;
    private long price;
    private long salePrice;
    private String productImage1;
    private String productImage2;
    private long productPoint;


    public long getSalePercentage(){
        if (salePrice == 0) {
            return 0;
        }
        //할인된 가격에 곱하기 100을 해서 원래 가격으로 나누면 할인율이 나옴
        return (price - salePrice) * 100 / price;
    }


}
