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
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/mall/more.js" defer></script>
<div>
  <p class="h3 my-3 text-center">- HIT 상품(더보기) -</p>

  <div class="row" id="displayHIT" style="text-align: left;">



  </div>

  <div>
    <p class="text-center">

      <span id="end" style="display:block; margin:20px; font-size: 14pt; font-weight: bold; color: red;"></span>
      <button type="button" class="btn btn-secondary btn-lg" id="btnMoreHIT" value="">더보기...</button>
      <button type="button" class="btn btn-secondary btn-lg" id="btnFirst" value="" style="display: none">처음으로</button>
      <span id="totalHITCount">${requestScope.hitCount}</span>
      <span id="countHIT">0</span>

    </p>
  </div>
</div>

<jsp:include page="../footer1.jsp"/>