<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 6. 4.
  Time: 오전 11:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String ctxPath = request.getContextPath();
%>
<jsp:include page="../header1.jsp"/>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/member/member_register.css"/>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="../login/login_cookie.jsp" ></script>
<script type="text/javascript" src="<%=ctxPath%>/js/member/memberRegister.js" defer></script>

<div class="row" id="divRegisterFrm">
    <div class="col-md-12">
        <form name="registerFrm">
            <table id="tblMemberRegister">
                <thead>
                <tr>
                    <th colspan="2">::: 회원가입 <span style="font-size: 10pt; font-style: italic;">(<span class="star">*</span>표시는 필수입력사항)</span> :::</th>
                </tr>
                </thead>

                <tbody>
                <tr>
                    <td colspan="2" style="line-height: 50%;">&nbsp;</td>
                </tr>

                <tr>
                    <td>성명&nbsp;<span class="star">*</span></td>
                    <td>
                        <input type="text" name="name" id="name" maxlength="30" class="requiredInfo" autofocus="autofocus"/>
                        <span class="error">성명은 필수입력 사항입니다.</span>
                    </td>
                </tr>

                <tr>
                    <td>아이디&nbsp;<span class="star">*</span></td>
                    <td>
                        <input type="text" name="userid" id="userid" maxlength="40" class="requiredInfo" />&nbsp;&nbsp;
                        <%-- 아이디중복체크 --%>
                        <img src="<%= ctxPath%>/images/b_id_check.gif" id="idcheck" />
                        <span id="idcheckResult"></span>
                        <span class="error">아이디는 필수입력 사항입니다.</span>
                    </td>
                </tr>

                <tr>
                    <td>비밀번호&nbsp;<span class="star">*</span></td>
                    <td>
                        <input type="password" name="pwd" id="pwd" maxlength="15" class="requiredInfo" />
                        <span class="error">암호는 영문자,숫자,특수기호가 혼합된 8~15 글자로 입력하세요.</span>
                    </td>
                </tr>

                <tr>
                    <td>비밀번호확인&nbsp;<span class="star">*</span></td>
                    <td>
                        <input type="password" id="pwdcheck" maxlength="15" class="requiredInfo" />
                        <span class="error">암호가 일치하지 않습니다.</span>
                    </td>
                </tr>

                <tr>
                    <td>이메일&nbsp;<span class="star">*</span></td>
                    <td>
                        <input type="text" name="email" id="email" maxlength="60" class="requiredInfo" />
                        <span class="error">이메일 형식에 맞지 않습니다.</span>
                        <%-- 이메일중복체크 --%>
                        <span id="emailcheck">이메일중복확인</span>
                        <span id="emailCheckResult"></span>
                    </td>
                </tr>

                <tr>
                    <td>연락처&nbsp;</td>
                    <td>
                        <input type="text" name="hp1" id="hp1" size="6" maxlength="3" value="010" readonly />&nbsp;-&nbsp;
                        <input type="text" name="hp2" id="hp2" size="6" maxlength="4" />&nbsp;-&nbsp;
                        <input type="text" name="hp3" id="hp3" size="6" maxlength="4" />
                        <span class="error">휴대폰 형식이 아닙니다.</span>
                    </td>
                </tr>

                <tr>
                    <td>우편번호</td>
                    <td>
                        <input  class="address" type="text" name="postcode" id="postcode" size="6" maxlength="5" />&nbsp;&nbsp;
                        <%-- 우편번호 찾기 --%>
                        <img src="<%= ctxPath%>/images/b_zipcode.gif" id="zipcodeSearch" />
                        <span class="error">우편번호 형식에 맞지 않습니다.</span>
                    </td>
                </tr>

                <tr>
                    <td>주소</td>
                    <td>
                        <input type="text" class="address" name="address" id="address" size="40" maxlength="200" placeholder="주소" /><br>
                        <input type="text" class="address" name="detailaddress" id="detailAddress" size="40" maxlength="200" placeholder="상세주소" />&nbsp;<input  class="address" type="text" name="extraaddress" id="extraAddress" size="40" maxlength="200" placeholder="참고항목" />
                        <span class="error">주소를 입력하세요.</span>
                    </td>
                </tr>

                <tr>
                    <td>성별</td>
                    <td>
                        <input type="radio" name="gender" value="1" id="male" /><label for="male" style="margin-left: 1.5%;">남자</label>
                        <input type="radio" name="gender" value="2" id="female" style="margin-left: 10%;" /><label for="female" style="margin-left: 1.5%;">여자</label>
                    </td>
                </tr>

                <tr>
                    <td>생년월일</td>
                    <td>
                        <input type="text" name="birthday" id="datepicker" maxlength="10" />
                        <span class="error">생년월일은 마우스로만 클릭하세요.</span>
                    </td>
                </tr>

                <%--
                   <tr>
                    <td>투숙기간</td>
                    <td>
                       시작일자: <input type="text" id="fromDate">&nbsp;&nbsp;
                       종료일자: <input type="text" id="toDate">
                    </td>
                 </tr>
                --%>

                <tr>
                    <td colspan="2">
                        <label for="agree">이용약관에 동의합니다</label>&nbsp;&nbsp;<input type="checkbox" id="agree" />
                    </td>
                </tr>

                <tr>
                    <td colspan="2">
                        <iframe src="<%= ctxPath%>/iframeagree/agree.html" width="100%" height="150px" style="border: solid 1px navy;"></iframe>
                    </td>
                </tr>

                <tr>
                    <td colspan="2" class="text-center">
                        <input type="button" class="btn btn-success btn-lg mr-5" value="가입하기" onclick="goRegister()" />
                        <input type="reset"  class="btn btn-danger btn-lg" value="취소하기" onclick="goReset()" />
                    </td>
                </tr>

                </tbody>
            </table>
            <%--
               <div>
                   <button onclick="goGaib()">type이 없으면 submit 임</button>&nbsp;
                   <button type="button" onclick="goGaib()">type이 button 인것</button>&nbsp;
                   <button type="submit">type이 submit 인 것</button>
               </div>
            --%>
        </form>
    </div>
</div>
<jsp:include page="../footer1.jsp"/>