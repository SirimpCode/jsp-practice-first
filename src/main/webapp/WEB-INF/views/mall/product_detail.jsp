<%@ page import="com.github.mymvcspring.repository.product.Product" %><%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 6. 27.
  Time: 오전 11:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    String ctxPath = request.getContextPath();
    Product product = (Product) request.getAttribute("product");
%>

<jsp:include page="../header1.jsp" />

<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css" />
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"></script>
<script>
    $(()=>{
        // $("div.loader").hide(); // CSS 로딩화면 감추기
        $("input#spinner").spinner( {
            spin: function(event, ui) {
                if(ui.value > 100) {
                    $(this).spinner("value", 100);
                    return false;
                }
                else if(ui.value < 1) {
                    $(this).spinner("value", 1);
                    return false;
                }
            }
        } );// end of $("input#spinner").spinner({});----------------
    })

    // ======= 추가이미지 캐러젤로 보여주기(Bootstrap Carousel 4개 표시 하되 1번에 1개 진행) 시작 ======= //
    $('div#recipeCarousel').carousel({
        interval : 2000  <%-- 2000 밀리초(== 2초) 마다 자동으로 넘어가도록 함(2초마다 캐러젤을 클릭한다는 말이다.) --%>
    });

    $('div.carousel div.carousel-item').each(function(index, elmt){
        <%--
             console.log($(elmt).html());
        --%>
        <%--
            <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle단가라포인트033.jpg">
            <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle덩크043.jpg">
            <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle트랜디053.jpg">
            <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle디스트리뷰트063.jpg">
        --%>

        let next = $(elmt).next();      <%--  다음엘리먼트    --%>
        <%-- console.log(next.length); --%>  <%--  다음엘리먼트개수 --%>
        <%--  1  1  1  0   --%>

        <%-- console.log("다음엘리먼트 내용 : " + next.html()); --%>
        <%--
            다음엘리먼트 내용 : <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle덩크043.jpg">
            다음엘리먼트 내용 : <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle트랜디053.jpg">
            다음엘리먼트 내용 : <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle디스트리뷰트063.jpg">
            다음엘리먼트 내용 : undefined
        --%>
        if (next.length == 0) { <%-- 다음엘리먼트가 없다라면 --%>
            <%--
              console.log("다음엘리먼트가 없는 엘리먼트 내용 : " + $(elmt).html());
             --%>
            <%--
                 다음엘리먼트가 없는 엘리먼트 내용 : <img class="d-block col-3 img-fluid" src="/MyMVC/images/berkelekle디스트리뷰트063.jpg">
            --%>

            //  next = $('div.carousel div.carousel-item').eq(0);
            //  또는
            //   next = $(elmt).siblings(':first'); <%-- 해당엘리먼트의 형제요소중 해당엘리먼트를 제외한 모든 형제엘리먼트중 제일 첫번째 엘리먼트 --%>
            //  또는
            next = $(elmt).siblings().first(); <%-- 해당엘리먼트의 형제요소중 해당엘리먼트를 제외한 모든 형제엘리먼트중 제일 첫번째 엘리먼트 --%>
            <%--
                 선택자.siblings() 는 선택자의 형제요소(형제태그)중 선택자(자기자신)을 제외한 나머지 모든 형제요소(형제태그)를 가리키는 것이다.
                 :first   는 선택된 요소 중 첫번째 요소를 가리키는 것이다.
                 :last   는 선택된 요소 중 마지막 요소를 가리키는 것이다.
                 참조사이트 : https://stalker5217.netlify.app/javascript/jquery/

                 .first()   선택한 요소 중에서 첫 번째 요소를 선택함.
                 .last()   선택한 요소 중에서 마지막 요소를 선택함.
                 참조사이트 : https://www.devkuma.com/docs/jquery/%ED%95%84%ED%84%B0%EB%A7%81-%EB%A9%94%EC%86%8C%EB%93%9C-first--last--eq--filter--not--is-/
            --%>
        }

        $(elmt).append(next.children(':first-child').clone());
        <%-- next.children(':first-child') 은 결국엔 img 태그가 되어진다. --%>
        <%-- 선택자.clone() 은 선택자 엘리먼트를 복사본을 만드는 것이다 --%>
        <%-- 즉, 다음번 클래스가 carousel-item 인 div 의 자식태그인 img 태그를 복사한 img 태그를 만들어서
             $(elmt) 태그속에 있는 기존 img 태그 뒤에 붙여준다. --%>

        for(let i=0; i<2; i++) { // 남은 나머지 2개를 위처럼 동일하게 만든다.
            next = next.next();

            if (next.length == 0) {
                //   next = $(elmt).siblings(':first');
                //  또는
                next = $(elmt).siblings().first();
            }

            $(elmt).append(next.children(':first-child').clone());
        }// end of for--------------------------

        console.log(index+" => "+$(elmt).html());

    }); // end of $('div.carousel div.carousel-item').each(function(index, elmt)----
    // ======= 추가이미지 캐러젤로 보여주기(Bootstrap Carousel 4개 표시 하되 1번에 1개 진행) 끝 ======= //

</script>

<style>
    .product-card-container {
        max-width: 800px;
        margin: 40px auto;
        box-shadow: 0 4px 24px rgba(0,0,0,0.12);
        border-radius: 16px;
        background: #fff;
        overflow: hidden;
        font-family: 'Segoe UI', 'Malgun Gothic', Arial, sans-serif;
    }
    .product-card-row {
        display: flex;
        flex-wrap: wrap;
    }
    .product-card-image-area {
        flex: 1 1 300px;
        min-width: 260px;
        background: #f8f9fa;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 32px 16px;
    }
    .product-card-image-area img {
        border-radius: 8px;
        margin-bottom: 16px;
        max-width: 90%;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }
    .product-card-info-area {
        flex: 2 1 400px;
        padding: 32px 32px 32px 24px;
    }
    .product-card-title {
        font-size: 2rem;
        font-weight: 700;
        margin-bottom: 8px;
    }
    .product-card-category {
        color: #888;
        font-size: 1rem;
        margin-bottom: 20px;
    }
    .product-card-list {
        list-style: none;
        padding: 0;
        margin: 0 0 24px 0;
    }
    .product-card-list li {
        padding: 10px 0;
        border-bottom: 1px solid #eee;
        font-size: 1.05rem;
    }
    .product-card-list li:last-child {
        border-bottom: none;
    }
    .product-card-desc {
        margin-bottom: 20px;
        color: #333;
        white-space: pre-line;
    }
    .product-card-manual-btn {
        display: inline-block;
        padding: 8px 20px;
        background: #1976d2;
        color: #fff;
        border-radius: 6px;
        text-decoration: none;
        font-weight: 500;
        transition: background 0.2s;
    }
    .product-card-manual-btn:hover {
        background: #1256a3;
    }
    @media (max-width: 700px) {
        .product-card-row { flex-direction: column; }
        .product-card-info-area { padding: 24px 16px; }
    }
</style>

<div class="product-card-container">
    <div class="product-card-row">
        <div class="product-card-image-area">
            <c:if test="${not empty product.productImage1}">
                <img src="${product.productImage1}" alt="대표 이미지">
            </c:if>
            <c:if test="${not empty product.productImage2}">
                <img src="${product.productImage2}" alt="추가 이미지" style="max-width:60%;">
            </c:if>
        </div>
        <div class="product-card-info-area">
            <div class="product-card-title">${product.productName}</div>
            <div class="product-card-category">${product.category.categoryName}</div>
            <ul class="product-card-list">
                <li><strong>제조사:</strong> ${product.companyName}</li>
                <li><strong>재고:</strong> ${product.stock}</li>
                <li><strong>정가:</strong><fmt:formatNumber value="${product.price}" type="currency" maxFractionDigits="0" currencySymbol="₩"/> 원</li>
                <li><strong>할인가:</strong><fmt:formatNumber value="${product.salePrice}" type="currency" maxFractionDigits="0" currencySymbol="₩"/> 원</li>
                <li><strong>포인트:</strong> ${product.productPoint}</li>
                <li><strong>등록일:</strong> <c:out value="${product.createdAt}"/></li>
            </ul>
            <div class="product-card-desc">
                <strong>상품 설명:</strong><br>
                ${product.productContents}
            </div>
            <c:if test="${not empty product.productManualPath}">
                <a href="${product.productManualPath}" class="product-card-manual-btn" target="_blank">매뉴얼 다운로드</a>
            </c:if>
        </div>
    </div>
</div>
<%--<c:if test="${not empty product.productImages}">--%>
<%--    <div>--%>
<%--        <c:forEach var="img" items="${product.productImages}">--%>
<%--            <img src="${img.imagePath}" alt="추가 이미지" style="max-width:200px; margin-right:10px;"/>--%>
<%--        </c:forEach>--%>
<%--    </div>--%>
<%--</c:if>--%>
<%-- ==== 장바구니담기 또는 바로주문하기 폼 ==== --%>
<form name="cartOrderFrm">
    <ul class="list-unstyled mt-3">
        <li>
            <label for="spinner">주문개수&nbsp;</label>
            <input id="spinner" name="oqty" value="1" style="width: 110px;">
        </li>
        <li>
            <button type="button" class="btn btn-secondary btn-sm mr-3" onclick="goCart()">장바구니담기</button>
            <button type="button" class="btn btn-danger btn-sm" onclick="goOrder()">바로주문하기</button>
        </li>
    </ul>
</form>
<%--css 로딩 화면 구현--%>
<div style="display: flex; position: absolute; top: 30%; left: 37%; border: solid 0px blue;">
    <div class="loader" style="margin: auto"></div>
</div>


<%-- === 추가이미지 보여주기 시작 === --%>
<c:if test="${not empty product.productImages}">

    <%-- /////// 추가이미지 캐러젤로 보여주는 것 시작 //////// --%>
    <div class="row mx-auto my-auto" style="width: 100%;">
        <div id="recipeCarousel" class="carousel slide w-100" data-ride="carousel">
            <div class="carousel-inner w-100" role="listbox">
                <c:forEach var="imgfilename" items="${product.productImages}" varStatus="status">
                    <c:if test="${status.index == 0}">
                        <div class="carousel-item active">
                            <img class="d-block col-3 img-fluid" src="${imgfilename.imagePath}" style="cursor: pointer;" data-toggle="modal" data-target="#add_image_modal_view" data-dismiss="modal" onclick="modal_content(this)" />
                        </div>
                    </c:if>
                    <c:if test="${status.index > 0}">
                        <div class="carousel-item">
                            <img class="d-block col-3 img-fluid" src="${imgfilename.imagePath}" style="cursor: pointer;" data-toggle="modal" data-target="#add_image_modal_view" data-dismiss="modal" onclick="modal_content(this)" />
                        </div>
                    </c:if>
                </c:forEach>
            </div>
            <a class="carousel-control-prev" href="#recipeCarousel" role="button" data-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="sr-only">Previous</span>
            </a>
            <a class="carousel-control-next" href="#recipeCarousel" role="button" data-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="sr-only">Next</span>
            </a>
        </div>
    </div>
    <%-- /////// 추가이미지 캐러젤로 보여주는 것 끝 //////// --%>
</c:if>
<%-- === 추가이미지 보여주기 끝 === --%>


<div>
    <p id="order_error_msg" class="text-center text-danger font-weight-bold h4"></p>
</div>

<div class="jumbotron mt-5">

    <div class="text-left" style="margin-top: -5%;">
        <p class="h4 bg-secondary text-white w-50">${requestScope.pvo.pname} 제품의 특징</p>
        <p>${requestScope.pvo.pcontent}</p>
    </div>

    <div class="row">
        <div class="col" style="display: flex">
            <h3 style="margin: auto">
                <i class="fas fa-thumbs-up fa-2x" style="cursor: pointer;" onclick="golikeAdd('${requestScope.pvo.pnum}')"></i>
                <span id="likeCnt" class="badge badge-primary"></span>
            </h3>
        </div>

        <div class="col" style="display: flex">
            <h3 style="margin: auto">
                <i class="fas fa-thumbs-down fa-2x" style="cursor: pointer;" onclick="godisLikeAdd('${requestScope.pvo.pnum}')"></i>
                <span id="dislikeCnt" class="badge badge-danger"></span>
            </h3>
        </div>
    </div>

</div>

<div class="text-left">
    <p class="h4 text-muted">${requestScope.pvo.pname} 제품 사용후기</p>

    <div id="viewComments">
        <%-- 여기가 제품사용 후기 내용이 들어오는 곳이다. --%>
    </div>
</div>

<div class="row">
    <div class="col-lg-10">
        <form name="commentFrm">
            <textarea name="contents" style="font-size: 12pt; width: 100%; height: 150px;"></textarea>
            <input type="hidden" name="fk_userid" value="${sessionScope.loginuser.userid}" />
            <input type="hidden" name="fk_pnum" value="${requestScope.pvo.pnum}" />
        </form>
    </div>
    <div class="col-lg-2" style="display: flex;">
        <button type="button" class="btn btn-outline-secondary w-100 h-100" id="btnCommentOK" style="margin: auto;"><span class="h5">후기등록</span></button>
    </div>
</div>

</div>


<%-- ****** 추가이미지 보여주기 Modal 시작 ****** --%>
<div class="modal fade" id="add_image_modal_view"> <%-- 만약에 모달이 안보이거나 뒤로 가버릴 경우에는 모달의 class 에서 fade 를 뺀 class="modal" 로 하고서 해당 모달의 css 에서 zindex 값을 1050; 으로 주면 된다. --%>
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <!-- Modal header -->
            <div class="modal-header">
                <h4 class="modal-title">추가 이미지 원래크기 보기</h4>
                <button type="button" class="close idFindClose" data-dismiss="modal">&times;</button>
            </div>

            <!-- Modal body -->
            <div class="modal-body" id="add_image_modal-body">
            </div>

            <!-- Modal footer -->
            <div class="modal-footer">
                <button type="button" class="btn btn-danger idFindClose" data-dismiss="modal">Close</button>
            </div>
        </div>

    </div>
</div>
<%-- ****** 추가이미지 보여주기 Modal 끝 ****** --%>


<jsp:include page="../footer1.jsp" />