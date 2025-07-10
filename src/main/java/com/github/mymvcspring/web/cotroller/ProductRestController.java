package com.github.mymvcspring.web.cotroller;

import com.github.mymvcspring.repository.user.MyUser;
import com.github.mymvcspring.service.exceptions.CustomMyException;
import com.github.mymvcspring.service.product.ProductService;
import com.github.mymvcspring.web.dto.product.ProductRegisterRequest;
import com.github.mymvcspring.web.dto.product.ProductRegisterResponse;
import io.swagger.v3.oas.annotations.Parameter;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Objects;

@RestController
@RequestMapping("/api/product")
@RequiredArgsConstructor
public class ProductRestController {

    private final ProductService productService;




    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ProductRegisterResponse registerProduct(
            @RequestParam long categoryId,
            @RequestParam String productName,
            @RequestParam String companyName,
            @RequestParam long price,
            @RequestParam long salePrice,
            @RequestParam long productSpecId,
            @RequestParam String productContents,
            @RequestParam long productPoint,
            @RequestParam(defaultValue = "1") int stock,
            @RequestPart(required = false) MultipartFile productImage1,
            @RequestPart(required = false) MultipartFile productImage2,
            @RequestPart(required = false) MultipartFile productManual,
            @RequestPart(required = false) List<MultipartFile> extraFiles,
            @Parameter(hidden = true) @SessionAttribute(value = "loginUser", required = false) MyUser loginUser
    ) {

        if (loginUser == null || !loginUser.getUserId().equals("admin"))
            throw CustomMyException.fromMessage("운영자만 접근 할수 있습니다.");


        //상품 등록 요청 DTO 생성
        ProductRegisterRequest productRegisterRequest = ProductRegisterRequest.builder()
                .categoryId(categoryId)
                .productName(productName)
                .companyName(companyName)
                .price(price)
                .salePrice(salePrice)
                .productSpecId(productSpecId)
                .productContents(productContents)
                .productPoint(productPoint)
                .stock(stock)
                .productImage1(productImage1)
                .productImage2(productImage2)
                .productManual(productManual)
                .extraFiles(extraFiles)
                .build();

        return productService.registerProductLogic(productRegisterRequest);

//        //경로 결합 및 디렉토리 생성
//        Path dir = Paths.get(uploadPath, String.valueOf(categoryId), productName);
//        Files.createDirectories(dir);// 이미 있으면 아무일도 안함
//
//
//        //파일 업로드
//        String fileName = Objects.requireNonNull(productImage2.getOriginalFilename());
//
//        File dest = new File(dir, fileName);
//        try {
//            productImage2.transferTo(dest);
//        } catch (IOException e) {
//            throw new RuntimeException(e);
//        }
    }
}
