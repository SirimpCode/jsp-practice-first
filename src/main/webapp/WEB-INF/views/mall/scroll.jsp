<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 6. 18.
  Time: 오전 11:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%
%>

<jsp:include page="../header1.jsp"/>

<style>
    .card-hover {
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .card-hover:hover {
        background-color: #e6f2ff; /* 은은한 하늘색 */
    }

    /*카테고리*/

    .header {
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        justify-content: center;
        padding: 20px 20px;
        border-bottom: 1px solid #eee;
        position: relative;
    }

    /* 카테고리 영역 */
    .categories {
        display: flex;
        gap: 20px;
        flex: 1;
        justify-content: center;
        flex-wrap: wrap;
    }

    /* 정렬박스는 오른쪽 끝으로 */
    .sort-box {
        margin-left: auto;
    }

    /* 카테고리 밑줄 스타일 */
    .category {
        position: relative;
        padding-bottom: 5px;
        cursor: pointer;
        font-weight: bold;
        white-space: nowrap;
    }

    .category.active::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        height: 2px;
        width: 100%;
        background-color: black;
    }

    /* 셀렉트박스 스타일 */
    .sort-box select {
        padding: 5px 10px;
        font-size: 14px;
    }

    @media (max-width: 768px) {
        .header {
            flex-direction: column;
            align-items: stretch;
        }

        .sort-box {
            margin-left: 0;
            margin-top: 10px;
            align-self: flex-end;
        }

        .categories {
            justify-content: center;
        }
    }


</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/mall/scroll.js" defer></script>

<div class="header">
    <div class="categories">
        <div class="category" data-category="all">ALL</div>
        <div class="category active" data-category="hit">HIT</div>
        <div class="category" data-category="clothing">의류</div>
        <div class="category" data-category="book">도서</div>
        <div class="category" data-category="electronic">전자제품</div>
    </div>
    <div class="sort-box">
        <label>
            <select>
                <option data-sort="">SORT BY</option>
                <option data-sort="newest">신상품</option>
                <option data-sort="price_asc">낮은가격</option>
                <option data-sort="price_desc">높은가격</option>
            </select>
        </label>
    </div>
</div>
<div>
    <p class="h3 my-3 text-center" id="titleCategory">- HIT 상품(스크롤) -</p>

    <div class="row" id="displayHIT" style="text-align: left;">



    </div>

    <div>
        <p class="text-center">

            <span id="end" style="display:block; margin:20px; font-size: 14pt; font-weight: bold; color: red;"></span>
            <span id="totalHITCount">${requestScope.hitCount}</span>
            <span id="countHIT">0</span>

        </p>
    </div>
</div>

<jsp:include page="../footer1.jsp"/>