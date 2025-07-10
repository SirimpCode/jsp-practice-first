package com.github.mymvcspring.web.dto.product;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor(staticName = "of")
public class ProductRegisterResponse {
    private final long productId;
    private final String productName;
}
