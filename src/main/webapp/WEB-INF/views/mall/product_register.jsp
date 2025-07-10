<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../header2.jsp" />

<style type="text/css">
    table#tblProdInput {border: solid gray 1px;
        border-collapse: collapse; }

    table#tblProdInput td {border: solid gray 1px;
        padding-left: 10px;
        height: 50px; }

    .prodInputName {background-color: #e6fff2;
        font-weight: bold; }

    .error {color: red; font-weight: bold; font-size: 9pt;}

    div.fileDrop{ display: inline-block;
        width: 100%;
        height: 100px;
        overflow: auto;
        background-color: #fff;
        padding-left: 10px;}

    div.fileDrop > div.fileList > div.fileItem > span.delete{display:inline-block; width: 20px; border: solid 1px gray; text-align: center;}
    div.fileDrop > div.fileList > div.fileItem > span.delete:hover{background-color: #000; color: #fff; cursor: pointer;}
    div.fileDrop > div.fileList > div.fileItem > span.fileName{padding-left: 10px;}
    div.fileDrop > div.fileList > div.fileItem > span.fileSize{padding-right: 20px; float:right;}
    span.clear{clear: both;}




</style>

<script>
    let extraFiles = [];
    $(()=>{

        $('#btnRegister').on("click", (e)=>{
            e.preventDefault(); //기본 이벤트를 막아준다.)
            requestRegisterProduct();
        })
    })
    requestRegisterProduct = () => {
        alert("등록버튼 클릭됨");
        const form = document.forms['prodInputFrm'];
        const formData = new FormData(form);

        // extraFiles 배열의 파일들을 FormData에 추가
        extraFiles.forEach(file => {
            formData.append("extraFiles", file);
        });

        axios.post("/api/product", formData, {
            headers: {
                "Content-Type": "multipart/form-data"
            }
        })
            .then(response => {
                alert("등록 성공!");
                // 필요시 페이지 이동 등 처리
            })
            .catch(error => {
                alert("등록 실패: " + error);
            });
    }



    $("input#spinnerPqty").spinner({
        spin:function(event,ui){
            if(ui.value > 100) {
                $(this).spinner("value", 100);
                return false;
            }
            else if(ui.value < 1) {
                $(this).spinner("value", 1);
                return false;
            }
        }
    });// end of $("input#spinnerPqty").spinner()--------

    //제품 이미지 선택하면 화면에 이미지를 미리 보여주기 시작
    $(document).on("change", "input.img_file", (e)=>{
        const input_file = $(e.target).get(0);
        // console.log(input_file.files);
        /*
[[Prototype]]: FileListitem: ƒ item()length: (...)constructor: ƒ FileList()Symbol(Symbol.iterator): ƒ values()Symbol(Symbol.toStringTag): "FileList"get length: ƒ length()[[Prototype]]: Object
File {name: 'java-logo.png', lastModified: 1742197206184, lastModifiedDate: Mon Mar 17 2025 16:40:06 GMT+0900 (GMT+09:00), webkitRelativePath: '', size: 111619, …}
>>설명<<
             name : 단순 파일의 이름 string타입으로 반환 (경로는 포함하지 않는다.)
             lastModified : 마지막 수정 날짜 number타입으로 반환 (없을 경우, 현재 시간)
             lastModifiedDate: 마지막 수정 날짜 Date객체타입으로 반환
             size : 64비트 정수의 바이트 단위 파일의 크기 number타입으로 반환
             type : 문자열인 파일의 MIME 타입 string타입으로 반환
                    MIME 타입의 형태는 type/subtype 의 구조를 가지며, 다음과 같은 형태로 쓰인다.
                   text/plain
                   text/html
                   image/jpeg
                   image/png
                   audio/mpeg
                   video/mp4
                  ...
*/

        // jQuery선택자.get(0) 은 jQuery 선택자인 jQuery Object 를 DOM(Document Object Model) element 로 바꿔주는 것이다.
        // DOM element 로 바꿔주어야 순수한 javascript 문법과 명령어를 사용할 수 있게 된다.
        console.log(input_file.files[0].name); //파일이름
        console.log(input_file.files[0].size); //파일크기
        console.log(input_file.files[0].type); //파일타입
        console.log(input_file.files[0].lastModifiedDate); //마지막 수정날짜
        console.log(input_file.files[0].lastModified); //마지막 수정날짜(밀리세컨드로 반환)
        //자바스크립트에서 file 객체의 실제 데이터 내용물에 접근하기위해 FileReader 객체를 생성하여 사용한다.
        const fileReader = new FileReader();
        // FileReader.readAsDataURL() --> 파일을 읽고, result속성에 파일을 나타내는 URL을 저장 시켜준다.
        fileReader.readAsDataURL(input_file.files[0]);// 파일을 읽어서 URL로 변환
        //FileReader.onload --> 파일 읽기 완료 성공시에만 작동하도록 하는 것임.
        fileReader.onload = (e) => {
            // console.log(e.target.result); //파일의 URL
            //미리보기 이미지 태그에 src 속성으로 파일의 URL을 지정해준다.
            $("#previewImg").attr("src", e.target.result);
        }
    })



    // 드래그앤 드랍을 통한 파일 업로드
    $(document).on("drop", "#fileDrop", (e)=>{
        e.preventDefault(); //기본 이벤트를 막아준다.
        $("#fileDrop").css("background-color", "#fff");

        const files = e.originalEvent.dataTransfer.files; //드래그앤 드랍으로 가져온 파일들

        const formData = new FormData(document.forms['prodInputFrm']);

        if(files.length > 0) {
            const fileList = $("<div class='fileList'></div>");
            for(let i=0; i<files.length; i++) {
                const file = files[i];
                // 중복 검사: 이름과 크기가 같은 파일이 이미 있는지 확인
                const isDuplicate = extraFiles.some(f => f.name === file.name && f.size === file.size);
                if(isDuplicate) {
                    alert(file.name + " 파일은 이미 추가되었습니다.");
                    continue;
                }
                if(file.size > 1024 * 1024 * 10) { //10MB이상은 업로드 금지
                    alert(file.name+" 업로드 실패 파일크기는 10MB이하로만 가능합니다.");
                    continue;
                }
                const fileItem = $("<div class='fileItem'></div>"); // 각 파일별 래퍼
                const fileName = $("<span class='fileName'></span>").text(file.name);
                //파일크기는 MB 단위로 표시 toFixed(2) 는 소수점 둘째자리까지 표시
                const fileSize = $("<span class='fileSize'></span>").text((file.size / 1024 / 1024).toFixed(2) + " MB");

                const deleteBtn = $("<span class='delete'>X</span>");
                //파일 배열에 파일 객체 추가
                extraFiles.push(file);

                deleteBtn.on("click", (e)=>{
                    //파일 배열에서 해당 파일 객체 제거
                    const index = extraFiles.indexOf(file);
                    if(index > -1) {
                        extraFiles.splice(index, 1);
                    }
                    console.log(extraFiles)//지워지는거 확인완료.
                    $(e.target).parent(".fileItem").remove();
                });
                fileItem.append(fileName).append(fileSize).append(deleteBtn);
                fileList.append(fileItem);
            }
            fileList.append("<span class='clear'></span>");
            // $("#fileDrop").empty().append(fileList);//기존값들 제거후 새로 드레그해온거 붙여넣음
            //기존의 값이 있다면 추가하는 방식으로 변경
            if($("#fileDrop > .fileList").length > 0) {
                $("#fileDrop > .fileList").append(fileList.children());
            } else {
                $("#fileDrop").append(fileList);
            }
        }
    });

    $(document).on("dragover", "#fileDrop", (e)=>{
        e.preventDefault(); //기본 이벤트를 막아준다.
        $("#fileDrop").css("background-color", "#ffd8d8");
    });
    $(document).on("dragleave", "#fileDrop", (e)=>{
        e.preventDefault(); //기본 이벤트를 막아준다.
        $("#fileDrop").css("background-color", "#fff");
    });



</script>

<div align="center" style="margin-bottom: 20px;">

    <div style="border: solid green 2px; width: 250px; margin-top: 20px; padding-top: 10px; padding-bottom: 10px; border-left: hidden; border-right: hidden;">
        <span style="font-size: 15pt; font-weight: bold;">제품등록&nbsp;[관리자전용]</span>
    </div>
    <br/>

    <%-- !!!!! ==== 중요 ==== !!!!! --%>
    <%-- 폼에서 파일을 업로드 하려면 반드시 method 는 POST 이어야 하고
         enctype="multipart/form-data" 으로 지정해주어야 한다.!! --%>
    <form name="prodInputFrm" enctype="multipart/form-data">

        <table id="tblProdInput" style="width: 80%;">
            <tbody>
            <tr>
                <td width="25%" class="prodInputName" style="padding-top: 10px;">카테고리</td>
                <td width="75%" align="left" style="padding-top: 10px;" >
                    <select name="categoryId" required>
                        <option value="">:::선택하세요:::</option>
                        <c:forEach var="category" items="${categoryList}">
                            <option value="${category.categoryId}">${category.categoryName}</option>
                        </c:forEach>
                    </select>
                    <span class="error">필수입력</span>
                </td>
            </tr>
            <tr>
                <td width="25%" class="prodInputName">제품명</td>
                <td width="75%" align="left" style="border-top: hidden; border-bottom: hidden;" >
                    <input type="text" style="width: 300px;" name="productName" class="box infoData" />
                    <span class="error">필수입력</span>
                </td>
            </tr>
            <tr>
                <td width="25%" class="prodInputName">제조사</td>
                <td width="75%" align="left" style="border-top: hidden; border-bottom: hidden;">
                    <input type="text" style="width: 300px;" name="companyName" class="box infoData" />
                    <span class="error">필수입력</span>
                </td>
            </tr>
            <tr>
                <td width="25%" class="prodInputName">제품이미지</td>

                <td width="75%" align="left" style="border-top: hidden; border-bottom: hidden;">
                                                                                    <%--이미지파일만--%>
                    <input type="file" name="productImage1" class="infoData img_file" accept='image/*' /><span class="error">필수입력</span>
                    <input type="file" name="productImage2" class="infoData img_file" accept='image/*' /><span class="error">필수입력</span>
                </td>
            </tr>
            <tr>
                <td width="25%" class="prodInputName">제품설명서 파일첨부(선택)</td>
                <td width="75%" align="left" style="border-top: hidden; border-bottom: hidden;">
                    <input type="file" name="productManual" />
                </td>
            </tr>
            <tr>
                <td width="25%" class="prodInputName">제품수량</td>
                <td width="75%" align="left" style="border-top: hidden; border-bottom: hidden;">
                    <input id="spinnerPqty" name="stock" value="1" style="width: 30px; height: 20px;"> 개
                    <span class="error">필수입력</span>
                </td>
            </tr>
            <tr>
                <td width="25%" class="prodInputName">제품정가</td>
                <td width="75%" align="left" style="border-top: hidden; border-bottom: hidden;">
                    <input type="text" style="width: 100px;" name="price" class="box infoData" /> 원
                    <span class="error">필수입력</span>
                </td>
            </tr>
            <tr>
                <td width="25%" class="prodInputName">제품판매가</td>
                <td width="75%" align="left" style="border-top: hidden; border-bottom: hidden;">
                    <input type="text" style="width: 100px;" name="salePrice" class="box infoData" /> 원
                    <span class="error">필수입력</span>
                </td>
            </tr>
            <tr>
                <td width="25%" class="prodInputName">제품스펙</td>
                <td width="75%" align="left" style="border-top: hidden; border-bottom: hidden;">
                    <select name="productSpecId" required>
                        <option value="">:::선택하세요:::</option>
                        <c:forEach var="spec" items="${productSpecList}">
                            <option value="${spec.productSpecId}">${spec.productSpecName}</option>
                        </c:forEach>
                    </select>
                    <span class="error">필수입력</span>
                </td>
            </tr>
            <tr>
                <td width="25%" class="prodInputName">제품설명</td>
                <td width="75%" align="left" style="border-top: hidden; border-bottom: hidden;">
                    <textarea name="productContents" rows="5" cols="60"></textarea>
                </td>
            </tr>
            <tr>
                <td width="25%" class="prodInputName" style="padding-bottom: 10px;">제품포인트</td>
                <td width="75%" align="left" style="border-top: hidden; border-bottom: hidden; padding-bottom: 10px;">
                    <input type="number" style="width: 100px;" name="productPoint" class="box infoData" /> POINT
                    <span class="error">필수입력</span>
                </td>
            </tr>

            <%-- ==== 추가이미지파일을 마우스 드래그앤드롭(DragAndDrop)으로 추가하기 ==== --%>
            <tr>
                <td width="25%" class="prodInputName" style="padding-bottom: 10px;">추가이미지파일(선택)</td>
                <td>
                    <span style="font-size: 10pt;">파일을 1개씩 마우스로 끌어 오세요</span>
                    <div id="fileDrop" class="fileDrop border border-secondary"></div>
                </td>
            </tr>

            <%-- ==== 이미지파일 미리보여주기 ==== --%>
            <tr>
                <td width="25%" class="prodInputName" style="padding-bottom: 10px;">이미지파일 미리보기</td>
                <td>
                    <img id="previewImg" width="300" />
                </td>
            </tr>

            <tr style="height: 70px;">
                <td colspan="2" align="center" style="border-left: hidden; border-bottom: hidden; border-right: hidden; padding: 50px 0;">
                    <input type="button" value="제품등록" id="btnRegister" style="width: 120px;" class="btn btn-info btn-lg mr-5" />
                    <input type="reset" value="취소"  style="width: 120px;" class="btn btn-danger btn-lg" />
                </td>
            </tr>
            </tbody>
        </table>

    </form>

</div>

<jsp:include page="../footer2.jsp" />
