package com.github.mymvcspring.repository.product;

import jakarta.persistence.*;
import lombok.Getter;

@Entity
@Getter
@Table(name = "product_image")
public class ProductImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long productImageId;

    @JoinColumn(name = "product_id")
    @ManyToOne(fetch = FetchType.LAZY)
    private Product product;
    private String imagePath;

    public static ProductImage fromProductAndImagePath(Product product,String imagePath){
        ProductImage productImage = new ProductImage();
        productImage.imagePath = imagePath;
        productImage.product = product;
        return productImage;
    }

}
