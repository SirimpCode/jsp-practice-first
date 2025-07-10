package com.github.mymvcspring.web.dto.product;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Getter
@Setter
@Builder
public class ProductRegisterRequest {
    private long categoryId;
    private String productName;
    private String companyName;
    private long price;
    private long salePrice;
    private long productSpecId;
    private String productContents;
    private long productPoint;
    private long stock;

    private MultipartFile productImage1;
    private MultipartFile productImage2;
    private MultipartFile productManual;
    private List<MultipartFile> extraFiles;

}
