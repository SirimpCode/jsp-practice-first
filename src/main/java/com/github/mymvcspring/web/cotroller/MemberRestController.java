package com.github.mymvcspring.web.cotroller;

import com.github.mymvcspring.repository.user.MyUser;
import com.github.mymvcspring.service.MemberService;
import com.github.mymvcspring.service.exceptions.CustomMyException;
import com.github.mymvcspring.web.dto.*;
import com.github.mymvcspring.web.dto.auth.*;
import com.github.mymvcspring.web.dto.member.CoinUpdateRequest;
import com.github.mymvcspring.web.dto.member.CoinUpdateResponse;
import com.github.mymvcspring.web.viewcontroller.ViewController;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/member")
@RequiredArgsConstructor
public class MemberRestController {
    private final MemberService memberService;
    private final ViewController viewController;
    @GetMapping("/check-id")
    public boolean duplicateCheckId(@RequestParam String userId){
        return memberService.duplicateCheckId(userId);
    }
    @GetMapping("/check-email")
    public boolean duplicateCheckEmail(@RequestParam String email, HttpServletRequest request){
        MyUser loginUser = (MyUser) request.getSession().getAttribute("loginUser");

        if (loginUser != null) {
            // 로그인된 사용자의 이메일과 중복 체크하려는 이메일이 같으면 중복 체크를 하지 않음
            String decodedEmail = viewController.decryption(loginUser.getEmail());
            if (decodedEmail.equals(email)) {
                return false;
            }
        }
        return memberService.duplicateCheckEmail(email);
    }
    @PostMapping("/register")
    public String registerUser(@RequestBody SignUpRequest signUpRequest) {
        signUpRequest.defaultSetting();
        memberService.registerLogic(signUpRequest);
        return signUpRequest.getName();
    }


    //쿠키 생성방식 메서드
    private Cookie createOrDeleteCookie(String userId, boolean rememberMe) {
        Cookie cookie = new Cookie("saveId", userId);
        if (rememberMe) {
            cookie.setMaxAge(60 * 60 * 24); // 쿠키 유효기간 1일
        } else {
            cookie.setMaxAge(0); // 쿠키 삭제
        }
        cookie.setPath("/"); // 모든 경로에서 사용 가능
        return cookie;
    }
    @GetMapping("/find-id")
    public Map<String, Object> findUserId(@ModelAttribute FindUserRequest emailAndName){
        String userId = memberService.findUserInfoLogic(emailAndName);
        boolean existsUser = userId != null;
        return Map.of("userId", existsUser ? userId:"", "success", existsUser);
    }
    @GetMapping("/find-pwd")
    public Map<String, Boolean> findPassword(@ModelAttribute FindUserRequest emailAndName){
        boolean existsUser = memberService.searchUserExists(emailAndName);
        return Map.of("success", existsUser);
    }



    @PostMapping("/login")
    public LoginResponse loginUser(@RequestBody LoginRequest loginRequest, HttpServletRequest request, HttpServletResponse response) {
        System.out.println(loginRequest.getPassword());
        // 클라이언트의 IP 주소를 얻어오는 것
        String clientIP = request.getHeader("X-Forwarded-For");
        if (clientIP != null && clientIP.contains(","))
            clientIP = clientIP.split(",")[0].trim();
        if (clientIP == null || clientIP.isEmpty())
            clientIP = request.getRemoteAddr();//이렇게 하면 IPv4 주소를 가져옴
        System.out.println("Client IP: " + clientIP);;//IPv6 주소 Client IP: 0:0:0:0:0:0:0:1 -Djava.net.preferIPv4Stack=true 를 VM 옵션에 추가하면 IPv4 주소로 변경됨
        LoginResponse loginResponse = memberService.loginLogic(loginRequest, request.getSession(), clientIP);

       // if(loginResponse.isSuccess()){
            //로그인성공시 쿠키 생성
            //Cookie cookie = createOrDeleteCookie(loginResponse.getUserId(),loginRequest.isRememberMe());
            //response.addCookie(cookie);
            /* Path를 /로 설정하면:
              /, /login, /user/profile, /admin 등 모든 서브경로에 대해 이 쿠키가 브라우저에서 자동으로 전송된다.

              Path를 /login으로 설정하면:
                  /login, /login/check, /login/form 등 /login으로 시작하는 경로에서만 쿠키가 전송된다.
                  /, /main, /user 등의 다른 경로에서는 이 쿠키는 사용되지 않음.
           */
   //     }
        //자바 서블릿에서 쿠키 이름이 saveId 인 쿠키의 MaxAge를 0으로 설정하면 해당 쿠키는 즉시 삭제됩니다.



        return loginResponse;
    }
    @PostMapping("/logout")
    public Map<String,Object> logoutUser(HttpServletRequest request) {
        //두가지 방법이있음 세션을 그대로 존재하게 두고 세션에 저장되어있는 어떤 값 (지금은 로그인 되어진 객체)을 제거
//        request.getSession().removeAttribute("loginUser"); 이런방법도잇음

        //세션을 무효화 시키는 방법
        try{
            request.getSession().invalidate(); // 세션 무효화
            return Map.of("success", true, "message", "빠이"); // 로그아웃 후 리다이렉트할 URL
        }catch (Exception e){
            return Map.of("success", false, "message", e.getMessage());
        }
    }


    @GetMapping("/my-test")
    public MyUser myTest(String userId){
        return memberService.getUserById(userId);
    }
    @GetMapping("/my-test2")
    public boolean myTest2(String userId){
        return memberService.checkId(userId);
    }

    @GetMapping("/last-login-test")
    public LocalDateTime lastLoginTest(String userId) {
        return memberService.getLastLoginHistory(userId).getLoginDate();
    }

    @PostMapping("/update-password")
    public CustomResponse<Void> updatePassword(@RequestBody PwChangeRequest pwChangeRequest) {
        if(!pwChangeRequest.getPassword().equals(pwChangeRequest.getPasswordConfirm()))
            throw CustomMyException.fromMessage("비밀번호와 비밀번호 변경이 일치하지 않습니다.");
        memberService.changePassword(pwChangeRequest);
        return CustomResponse.emptyDataOk("비밀번호 변경 성공");
    }
    @PutMapping("/coin")
    public CustomResponse<CoinUpdateResponse>  updateCoin(@RequestBody CoinUpdateRequest coinUpdateRequest, HttpServletRequest request) {
        return CustomResponse.ofOk("코인 업데이트 성공",memberService.updateCoinProcess(coinUpdateRequest, request.getSession()));
    }
    @PutMapping
    public CustomResponse<Void> updateUser(@RequestBody UserInfoEditRequest editRequest, HttpServletRequest request) {

        String referer = request.getHeader("referer");
        if (referer == null || !referer.contains("/member/memberEdit.up")) {
            throw CustomMyException.fromMessage("잘못된 접근입니다.");
        }

        MyUser loginUser = (MyUser) request.getSession().getAttribute("loginUser");

        memberService.updateUserInfo(editRequest, loginUser);

        return CustomResponse.emptyDataOk("회원 정보 수정 성공");

    }



}
