package com.github.mymvcspring.repository.product;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface ProductRepository extends JpaRepository<Product, Long>, ProductRepositoryCustom {

    long countByProductSpec(ProductSpec productSpec);

    @Query("SELECT p FROM Product p LEFT JOIN FETCH p.productImages JOIN FETCH p.category JOIN FETCH p.productSpec WHERE p.productId = :productId")
    Optional<Product> findByIdAllFetchJoin(long productId);
}
