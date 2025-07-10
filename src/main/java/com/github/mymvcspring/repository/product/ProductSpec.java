package com.github.mymvcspring.repository.product;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Getter;

@Entity
@Getter
public class ProductSpec {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long productSpecId;
    private String productSpecName;

    public static ProductSpec onlyId(long id){
        ProductSpec productSpec = new ProductSpec();
        productSpec.productSpecId = id;
        return productSpec;
    }
}
