<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 6. 25.
  Time: 오전 9:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../header1.jsp" />
<script>
    $(function () {
        $("#pqty").spinner({
            min: 1,
            max: 1000
        });
    });
</script>

<body>
<h2>제품등록 [관리자전용]</h2>

<form action="/admin/productRegister" method="post" enctype="multipart/form-data">
    <table border="1" cellspacing="0" cellpadding="5">

        <!-- 카테고리 -->
        <tr>
            <th>카테고리</th>
            <td>
                <select name="fk_cnum" required>
                    <option value="">:::선택하세요:::</option>
                    <c:forEach var="category" items="${categoryList}">
                        <option value="${category.categoryId}">${category.categoryName}</option>
                    </c:forEach>
                </select>
            </td>
        </tr>

        <!-- 제품명 -->
        <tr>
            <th>제품명</th>
            <td><input type="text" name="pname" required></td>
        </tr>

        <!-- 제조사 -->
        <tr>
            <th>제조사</th>
            <td><input type="text" name="pcompany" required></td>
        </tr>

        <!-- 제품이미지 -->
        <tr>
            <th>제품이미지</th>
            <input type="file" name="pimage1" required>
            <input type="file" name="pimage2" required>
        </tr>

        <!-- 설명서 파일 -->
        <tr>
            <th>제품설명서 파일(선택)</th>
            <td><input type="file" name="manualFile"></td>
        </tr>

        <!-- 제품수량 -->
        <tr>
            <th>제품수량</th>
            <td><input type="text" id="pqty" name="pqty" value="1"> 개</td>
        </tr>

        <!-- 제품정가 -->
        <tr>
            <th>제품정가</th>
            <td><input type="number" name="pgrade" required> 원</td>
        </tr>

        <!-- 판매가 -->
        <tr>
            <th>제품판매가</th>
            <td><input type="number" name="price" required> 원</td>
        </tr>

        <!-- 제품스펙 -->
        <tr>
            <th>제품스펙</th>
            <td>
                <select name="fk_snum" required>
                    <option value="">:::선택하세요:::</option>
                    <c:forEach var="spec" items="${productSpecList}">
                        <option value="${spec.productSpecId}">${spec.productSpecName}</option>
                    </c:forEach>
                </select>
            </td>
        </tr>

        <!-- 제품설명 -->
        <tr>
            <th>제품설명</th>
            <td><textarea name="pcontent" rows="5" cols="50"></textarea></td>
        </tr>

        <!-- 포인트 -->
        <tr>
            <th>제품포인트</th>
            <td><input type="text" name="point"> POINT</td>
        </tr>

        <!-- 추가 이미지파일 -->
        <tr>
            <th>추가이미지파일(선택)</th>
            <td>
                <input type="file" name="addImages" id="addImages" multiple>
                <p>파일을 1개씩 마우스로 끌어 오세요</p>
            </td>
        </tr>

        <!-- 이미지 미리보기 -->
        <tr>
            <th>이미지파일 미리보기</th>
            <td>
                <div id="previewArea">
                    <span style="color:red;">순서상 마지막으로 첨부된 이미지 파일이 자동적으로 여기에 미리보기가 되어지도록 만든다.</span>
                </div>
            </td>
        </tr>

        <!-- 등록 버튼 -->
        <tr>
            <td colspan="2" align="center">
                <button type="submit">제품등록</button>
                <button type="reset">취소</button>
            </td>
        </tr>

    </table>
</form>

<script>
    $('#addImages').on('change', function (event) {
        const files = event.target.files;
        const previewArea = $('#previewArea');
        previewArea.empty(); // 기존 미리보기 초기화

        if (files.length > 0) {
            const lastFile = files[files.length - 1];
            const reader = new FileReader();

            reader.onload = function (e) {
                previewArea.append(`<img src="${e.target.result}" width="150" style="margin-top: 10px;">`);
            };

            reader.readAsDataURL(lastFile);
        }
    });
</script>
</body>

<jsp:include page="../footer1.jsp" />
