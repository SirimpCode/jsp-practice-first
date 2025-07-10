package com.github.mymvcspring.service.product;

import com.github.mymvcspring.repository.product.Product;
import com.github.mymvcspring.repository.product.ProductImage;
import com.github.mymvcspring.repository.product.ProductRepository;
import com.github.mymvcspring.service.exceptions.CustomMyException;
import com.github.mymvcspring.web.dto.PaginationDto;
import com.github.mymvcspring.web.dto.product.ProductListRequest;
import com.github.mymvcspring.web.dto.product.ProductListResponse;
import com.github.mymvcspring.web.dto.product.ProductRegisterRequest;
import com.github.mymvcspring.web.dto.product.ProductRegisterResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.regex.Pattern;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductService {
    private final ProductRepository productRepository;

    @Value("${file.upload.directory}")
    private String uploadPath;


    public Optional<PaginationDto<ProductListResponse>> getHitProductList(long page, String specName) {
        PaginationDto<ProductListResponse> response = productRepository.findAllProductsBySpecName(page, specName);
        return Optional.ofNullable(response);
    }


    public Optional<PaginationDto<ProductListResponse>> getProductListByRequest(ProductListRequest request) {
        PaginationDto<ProductListResponse> response = productRepository.findAllByCategoryOrderBySort(request);
        return Optional.ofNullable(response);

    }

    @Transactional
    public ProductRegisterResponse registerProductLogic(ProductRegisterRequest productRegisterRequest ) {
        //save 를 먼저 해야됨 productId가 있어야 파일 저장 경로를 만들 수 있기 때문
        //트랜잭션 때문에 첨부파일 저장 로직은 나중에 실행된다.
        //즉 imagePath 등은 아직 null 이다.
        Product product = Product.ofRequest(productRegisterRequest);
        productRepository.save(product);

        Path uploadDir = createFileDirectory(product.getProductId(), product.getProductName(), productRegisterRequest.getCategoryId());

        //db 저장을위해 먼저 저장될 경로를 가져오기
        Path image1Path = createFilePathIfPresent(uploadDir, productRegisterRequest.getProductImage1(), "productImage1_");
        String image1WebPath = createWebPath(image1Path);
        Path image2Path = createFilePathIfPresent(uploadDir, productRegisterRequest.getProductImage2(), "productImage2_");
        String image2WebPath = createWebPath(image2Path);
        Path manualPath = createFilePathIfPresent(uploadDir, productRegisterRequest.getProductManual(), "productManual_");
        String manualWebPath = createWebPath(manualPath);
        List<Path> extraFilePaths = new ArrayList<>();
        for (int i = 0; i < productRegisterRequest.getExtraFiles().size(); i++) {
            Path extraFilePath = createFilePathIfPresent(uploadDir, productRegisterRequest.getExtraFiles().get(i), "extraFile_" + (i + 1) + "_");
            extraFilePaths.add(extraFilePath);
        }
        List<String> extraFileWebPaths = extraFilePaths.stream()
                .map(path -> createWebPath(path)).toList();

        List<ProductImage> productImages = extraFileWebPaths.stream().map(path-> ProductImage.fromProductAndImagePath(product,path)).toList();

        product.updateProductImages(image1WebPath, image2WebPath, manualWebPath, productImages);



        return ProductRegisterResponse.of(product.getProductId(), product.getProductName());
    }

    private Path createFilePathIfPresent(Path uploadDir, MultipartFile file, String attachType) {
        if (file == null || file.isEmpty())
            return null; // 파일이 없으면 null 반환

        if (file.getOriginalFilename() == null || file.getOriginalFilename().isEmpty())
            throw CustomMyException.fromMessage("알 수 없는 오류 : 파일 이름이 비어있습니다.");
        Path dest = uploadDir.resolve(attachType + file.getOriginalFilename());
        //dest는 "destination(목적지)"의 약어로, 파일이 저장될 최종 경로(목적지 파일 경로)를 의미합니다.
        try {
            file.transferTo(dest.toFile()); // 중복이 있을 시 덮어 씌워진다. 주의
            return dest; // 저장된 파일의 경로 반환
        } catch (IOException e) {
            log.error("파일 저장 중 오류 발생: {}", e.getMessage(), e);
            throw CustomMyException.fromMessage("파일 저장 중 오류가 발생했습니다. 다시 시도해주세요.");
        }
    }

    private Path createFileDirectory(long productId, String productName, long categoryId) {
        // 카테고리별로 디렉토리를 생성하고, 상품 ID와 이름을 조합하여 하위 디렉토리를 생성
        Path uploadDir = Paths.get(uploadPath, String.valueOf(categoryId), productId + "_" + productName);
        /*
        상대경로
        프로젝트 루트 기준: Paths.get(System.getProperty("user.dir"), "uploads", fileName)
        정적 폴더 기준: Paths.get("src/main/resources/static/uploads", fileName)
         */
        try {
            Files.createDirectories(uploadDir);// 이미 있다면 아무일도 안일어남.
        } catch (IOException e) {
            log.error("디렉토리 생성 중 오류 발생: {}", e.getMessage(), e);
            throw CustomMyException.fromMessage("디렉토리 생성 중 오류가 발생했습니다. 다시 시도해주세요.");
        }
        return uploadDir;
    }

    private Map<String, String> saveProductFiles(ProductRegisterRequest request, long productId) throws IOException {
        // 파일 저장 로직 구현
        Path uploadDir = Paths.get(uploadPath, String.valueOf(request.getCategoryId()), productId + "_" + request.getProductName());
        Files.createDirectories(uploadDir);// 이미 있다면 아무일도 안일어남.

        // 단일 파일들
        String image1Path = saveIfPresent(request.getProductImage1(), uploadDir, "productImage1_");
        String image2Path = saveIfPresent(request.getProductImage2(), uploadDir, "productImage2_");
        String manualPath = saveIfPresent(request.getProductManual(), uploadDir, "productManual_");
        // 여러 파일
        List<String> extraFilePaths = new ArrayList<>();
        if (request.getExtraFiles() != null) {
            for (int i = 0; i < request.getExtraFiles().size(); i++) {
                String path = saveIfPresent(request.getExtraFiles().get(i), uploadDir, "extraFile_" + (i + 1) + "_");
                if (path != null)
                    extraFilePaths.add(path);
            }
        }
        Map<String, String> filePaths = new HashMap<>();
        filePaths.put("productImage1", image1Path);
        filePaths.put("productImage2", image2Path);
        filePaths.put("productManual", manualPath);
        for (int i = 0; i < extraFilePaths.size(); i++) {
            filePaths.put("extraFile" + (i + 1), extraFilePaths.get(i));
        }
        return filePaths; // 파일 경로들을 반환
    }

    // 파일이 있다면 로컬디스크에 저장하고, 저장된 파일의 경로를 반환하는 메소드
    private String saveIfPresent(MultipartFile file, Path dir, String attachType) throws IOException {
        if (file != null && !file.isEmpty()) {
            if (file.getOriginalFilename() == null || file.getOriginalFilename().isEmpty())
                throw CustomMyException.fromMessage("알 수 없는 오류 : 파일 이름이 비어있습니다.");
            Path dest = dir.resolve(attachType + file.getOriginalFilename());
            file.transferTo(dest.toFile());//중복이 있을시 덮어 씌워진다. 주의
            //log.info("파일이 저장된 경로: {}", dest.toAbsolutePath().toString().replace('\\','/'));
            // 파일 경로를 '/'로 변경후 로그 찍고 반환
            String filePath = normalizePath(dest.toAbsolutePath().toString());
            String webPath = filePath.replaceFirst("^" + Pattern.quote(uploadPath), "/uploads/");
            log.info("파일이 저장된 경로: {}", webPath);//"^"은 문자열의 시작 정규식, Pattern.quote(uploadPath)는 uploadPath 문자열을 정규식으로 안전하게 처리하기 위한 방법

            return webPath; // 웹에서 접근할 수 있는 경로로 반환

            //log.info("<UNK> <UNK> <UNK>: {}", replacePath);
            //파일이 저장된 경로: c:/uploads\my-mvc-spring\1\0_ㅁㄴㅇㄹ\Untitled.sql
        }
        return null; // 파일이 없을 경우 null 반환
    }

    // 파일 경로를 웹에서 접근할 수 있는 경로로 변환하는 메소드
    private String createWebPath(Path path) {
        // 파일 경로를 '/'로 변경하고, uploadPath를 '/uploads/'로 대체
        if (path == null)
            return null;
        String normalizedPath = normalizePath(path.toString());
        return normalizedPath.replaceFirst("^" + Pattern.quote(uploadPath), "/uploads/");
    }

    // 경로를 '/'로 변경하는 메소드
    private String normalizePath(String path) {
        return path.replace('\\', '/');
    }

    public Product getProductAndImages(long productId) {
        Optional<Product> productOptional = productRepository.findByIdAllFetchJoin(productId);
        return productOptional.orElseThrow(()->
            CustomMyException.fromMessage("없는 상품 입니다.")
        );
    }
}
