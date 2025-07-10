package com.github.mymvcspring.repository.product;

import com.github.mymvcspring.web.dto.product.ProductRegisterRequest;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.DynamicInsert;

import java.time.LocalDateTime;
import java.util.List;


@Entity
@Getter
@NoArgsConstructor
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long productId;

    private String productName;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    private String companyName;
    private String productImage1;
    private String productImage2;

    private Long stock;
    private Long price;
    private Long salePrice;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_spec_id")
    private ProductSpec productSpec;
    private String productContents;
    private Long productPoint;
//    @Column(columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<ProductImage> productImages;

    private String productManualPath;


    public static Product ofRequest(ProductRegisterRequest request ) {
        Product product = new Product();
        product.category = Category.onlyId(request.getCategoryId());
        product.productName = request.getProductName();
        product.companyName = request.getCompanyName();
        product.price = request.getPrice();
        product.salePrice = request.getSalePrice();
        product.productSpec = ProductSpec.onlyId(request.getProductSpecId());
        product.productContents = request.getProductContents();
        product.productPoint = request.getProductPoint();
        product.stock = request.getStock();
        product.createdAt = LocalDateTime.now();
        return product;
    }


    public void updateProductImages(String image1WebPath, String image2WebPath, String manualWebPath, List<ProductImage> productImages) {
        this.productImage1 = image1WebPath;
        this.productImage2 = image2WebPath;
        this.productImages = productImages;
        this.productManualPath = manualWebPath;

    }
}
