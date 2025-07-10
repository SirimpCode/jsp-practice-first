package com.github.mymvcspring.web.viewcontroller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.mymvcspring.config.encryption.AES256;
import com.github.mymvcspring.repository.Image;
import com.github.mymvcspring.repository.product.Category;
import com.github.mymvcspring.repository.product.Product;
import com.github.mymvcspring.repository.product.ProductSpec;
import com.github.mymvcspring.repository.user.MyUser;
import com.github.mymvcspring.service.AdminService;
import com.github.mymvcspring.service.ViewService;

import com.github.mymvcspring.service.product.ProductService;
import com.github.mymvcspring.web.dto.ProductStatisticsResponse;
import com.github.mymvcspring.web.dto.StatisticsResponse;
import com.github.mymvcspring.web.dto.member.MemberListResponse;
import com.github.mymvcspring.web.dto.member.SearchConditions;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.http.client.ClientHttpRequestFactorySettings;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Controller
@RequiredArgsConstructor
public class ViewController {

    private final ViewService viewService;
    private final ClientHttpRequestFactorySettings clientHttpRequestFactorySettings;
    private final AES256 aes256;
    private final AdminService adminService;
    private final ProductService productService;

    @GetMapping("/shop/storeLocation.up")
    public String storeLocation(HttpServletRequest request) {
        return "mall/store_location";
    }

    @GetMapping("/test.do")
    public String test() {
        return "test/test";
    }

    @GetMapping("/index.up")
    public String index(HttpServletRequest request) {
        List<Image> imgList = viewService.getAllImages();
        request.setAttribute("imgList", imgList);
        return "index";
    }

    @GetMapping("/login/idFind.up")
    public String idFind() {
        return "login/id_find";
    }

    @GetMapping("/login/pwdFind.up")
    public String pwdFind() {
        return "login/pwd_find";
    }

    @GetMapping("/error.up")
    public void error() {

        throw new RuntimeException("에러가 발생했습니다.");
    }

    @GetMapping("/member/coinPurchaseTypeChoice.up")
    public String coinPurchaseTypeChoice(@RequestParam String userId, HttpServletRequest request) {

        MyUser loginUser = ((MyUser) request.getSession().getAttribute("loginUser"));
        String loginId = Optional.ofNullable(loginUser)
                .map(MyUser::getUserId)
                .orElse(null);
        boolean isNormal = userId != null && userId.equals(loginId)
                && normalApproach(request.getHeader("Referer"), "/index.up");
        request.setAttribute("isNormal", isNormal);

        if (isNormal)
            return "member/coin_charge";
        request.setAttribute("message", "잘못된 접근입니다.");
        return "simple_error";
    }

    @GetMapping("/member/cash.up")
    public String cash(HttpServletRequest request, HttpServletRequest response) {
        response.setAttribute("message", "");


        return "";
    }

    private boolean normalApproach(String referer, String sourceUrl) {
        return referer != null && referer.contains(sourceUrl);
    }

    @PostMapping("/member/cash.up")
    public String cashPost(@RequestParam String userId, HttpServletRequest request) {
        return "member/cash";
    }


    public String decryption(String encryptedData) {
        try {
            return aes256.decrypt(encryptedData);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("복호화에 실패했습니다.");
        }
    }

    @GetMapping("/member/coinPayment.up")
    public String coinPayment(@RequestParam String userId, @RequestParam String coin, @RequestParam String point,
                              HttpServletRequest request, HttpServletRequest response) {

        //원포트 결제창을 띄우기위한 전제조건은 먼저 로그인해야 하는것이다
        MyUser loginUser = (MyUser) request.getSession().getAttribute("loginUser");
        boolean isNormal = viewService.loginValidation(userId, loginUser) &&
                normalApproach(request.getHeader("Referer"), "/index.up");

        String decryptedEmail = decryption(loginUser.getEmail());
        String decryptedNumber = decryption(loginUser.getPhoneNumber());


        String productName = "코인 충전";
        request.setAttribute("productName", productName);
//        request.setAttribute("coinMoney", coin);
        request.setAttribute("coinMoney", "100");
        request.setAttribute("email", decryptedEmail);
        request.setAttribute("name", loginUser.getUserName());
        request.setAttribute("phoneNumber", decryptedNumber);
        request.setAttribute("point", point.replace(",", ""));
        request.setAttribute("realCoin", coin);
        request.setAttribute("userId", userId);

        Boolean 개빡치네 = false;

        if (isNormal)
            return "member/payment_gateway";
        response.setAttribute("message", "잘못된 접근입니다.");
        return "simple_error";
    }

    @GetMapping("/member/memberEdit.up")
    public String memberEdit(HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        System.out.println(referer);
        if (referer == null || !referer.contains("/index.up")) {
            request.setAttribute("message", "잘못된 접근입니다.");
            return "simple_error";
        }
        MyUser loginUser = (MyUser) request.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            request.setAttribute("message", "로그인이 필요합니다.");
            return "simple_error";
        }

        request.setAttribute("email", decryption(loginUser.getEmail()));
        request.setAttribute("phoneNumber", decryption(loginUser.getPhoneNumber()));
        request.setAttribute("user", loginUser);
        return "member/member_edit";
    }

    //관리자전용 회원전용
    @GetMapping("/admin/memberList.up")
    public String showMemberListByAdmin(HttpServletRequest request) {
        MyUser admin = (MyUser) request.getSession().getAttribute("loginUser");
        if (admin == null || !admin.getUserId().equals("admin")) {
            request.setAttribute("message", "관리자만 접근할 수 있습니다.");
            return "error";
        }
        return "member/admin/member_list";
    }

    @PostMapping("/admin/memberDetail.up")
    public String showMemberDetail(@RequestParam String userId,
                                   @RequestParam String prevPage,
                                   @RequestParam String prevSize,
                                   @RequestParam String prevSearchType,
                                   @RequestParam String prevSearchValue,
                                   HttpServletRequest request) {
        MyUser admin = (MyUser) request.getSession().getAttribute("loginUser");
        String referer = request.getHeader("Referer");
        if (referer == null || !referer.contains("/admin/memberList.up")) {
            request.setAttribute("message", "잘못된 접근입니다.");
            return "error";
        }
        if (admin == null || !admin.getUserId().equals("admin")) {
            request.setAttribute("message", "관리자만 접근할 수 있습니다.");
            return "error";
        }
        request.setAttribute("userId", userId);
        request.setAttribute("prevPage", prevPage);
        request.setAttribute("prevSize", prevSize);
        request.setAttribute("prevSearchType", prevSearchType);
        request.setAttribute("prevSearchValue", prevSearchValue);
        return "member/admin/member_detail";

    }


    @GetMapping("/mall/more.up")
    public String more(HttpServletRequest request) {
        long hitCount = viewService.getProductCountBySpec(1);
        request.setAttribute("hitCount", hitCount);
        return "mall/more";
    }

    @GetMapping("/mall/scroll.up")
    public String scroll(HttpServletRequest request) {
        long hitCount = viewService.getProductCountBySpec(1);
        request.setAttribute("hitCount", hitCount);
        return "mall/scroll";
    }

    @GetMapping("/admin/product.up")
    public String registerProduct(HttpServletRequest request) {
        MyUser loginUser = (MyUser) request.getSession().getAttribute("loginUser");
        if (loginUser == null || !loginUser.getUserId().equals("admin")) {
            request.setAttribute("message", "관리자만 접근할 수 있습니다.");
            return "error";
        }
        List<Category> categoryList = viewService.getAllCategories();
        List<ProductSpec> productSpecList = viewService.getAllProductSpecs();
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("productSpecList", productSpecList);
        return "mall/product_register";
    }
    @GetMapping("/test.up")
    public String testPage() {
        System.out.println(System.getProperty("user.dir"));
        return "test";
    }
    @GetMapping("/product/detail/{productId}/temp")
    public String productDetailTemp(@PathVariable long productId, HttpServletRequest request){
        Product product = productService.getProductAndImages(productId);
        request.setAttribute("product", product);
        return "mall/product_detail";
    }
    @GetMapping("/product/detail/{productId}")
    public String productDetail(@PathVariable long productId, HttpServletRequest request){
        Product product = productService.getProductAndImages(productId);
        request.setAttribute("product", product);
        return "mall/prod_view";
    }
    @GetMapping("/shop/chart")
    public String viewShopChart(HttpSession session, Model model){
        if (session.getAttribute("loginUser") == null) {
            model.addAttribute("message", "로그인이 필요합니다.");
            return "error";
        }
        MyUser loginUser = (MyUser) session.getAttribute("loginUser");
        model.addAttribute("loginUser", loginUser);
        List<StatisticsResponse> responses = viewService.obtainingStatistics();
        List<ProductStatisticsResponse> productStatistics = viewService.obtainingProductStatistics();
        String jsonResponses = parseJsonToString(responses);
        String jsonProductStatistics = parseJsonToString(productStatistics);
        model.addAttribute("statistics", jsonResponses);
        model.addAttribute("productStatistics", jsonProductStatistics);

        // 차트 페이지를 보여주는 메서드
        return "mall/shop_chart";
    }
    private String parseJsonToString(Object object){
        //객체를 JSON 문자열로 변환하는 메서드
        //이 메서드는 Jackson 라이브러리나 Gson 라이브러리를 사용하여 구현할 수 있습니다.
        //Jackson 라이브러리를 사용하는 예시:
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.writeValueAsString(object);
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("JSON 변환에 실패했습니다.");
        }

    }



    //강사님 버전
////    @GetMapping("/admin/memberList.up")
//    public void searchMemberList(
//
//            @ModelAttribute SearchConditions searchConditions,
//            @RequestParam(defaultValue = "1") long page,
//            @RequestParam(defaultValue = "10") long size,
//            HttpServletRequest request, HttpServletResponse response
//
//    ) {
//        // 관리자가 아니면 에러 페이지로 날려버림
//        MyUser admin = (MyUser) request.getSession().getAttribute("loginUser");
//        if (admin == null || !admin.getUserId().equals("admin")) {
//            request.setAttribute("message", "관리자만 접근할 수 있습니다.");
//            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/simple_error.jsp");
//            try {
//                dispatcher.forward(request, response);
//                return;
//            } catch (ServletException | IOException e) {
//                throw new RuntimeException(e);
//            }
//
//        }
//        if(searchConditions.getSearchValue()!=null)
//            searchConditions.covertSearchType();
//
//
//        PaginationDto<MemberListResponse> memberList =  adminService.searchMemberList(searchConditions, page, size)
//                .orElseThrow(()-> new RuntimeException("빈 목록이 아닌 null 반환"));
//        request.setAttribute("memberList", memberList);
//
//        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/member/admin/member_list.jsp");
//        try {
//            dispatcher.forward(request, response);
//        } catch (ServletException | IOException e) {
//            throw new RuntimeException(e);
//        }
//
//    }

}
