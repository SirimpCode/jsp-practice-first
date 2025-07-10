$(function (){
    // //쿠키읽어오기
    // const cookies = document.cookie;
    // console.log(cookies)
    // cookies.split('; ').forEach(cookie => {
    //     //=를 기준으로 모두 분리되고 첫번째 값은 name 두번째값음 value에 저장됨
    //     //두개 이상일경우 무시됨
    //
    //     const [name, value] = cookie.split('=');
    //     console.log(`Cookie Name: ${name}, Value: ${value}`);
    //     console.log();
    // })
    // // 접근 가능한 쿠키값을 읽어오는것 HttpOnly 쿠키는 읽을 수 없음

    /*   !!!!!! 필수로 기억해야 합니다. !!!!!!
         >>>> 로컬 스토리지(localStorage)와 세션 스토리지(sessionStorage) <<<<
         로컬 스토리지와 세션 스토리지는 HTML5에서 추가된 저장소이다.
         간단한 키와 값을 저장할 수 있다. 키-밸류 스토리지의 형태이다.

       ※ 로컬 스토리지와 세션 스토리지의 차이점은 데이터의 영구성이다.
          로컬 스토리지의 데이터는 사용자가 지우지 않는 이상 계속 브라우저에 남아 있게 된다.
          만료 기간을 설정할 수 없다.
          하지만 세션 스토리지의 데이터는 윈도우나 브라우저 탭을 닫을 경우 자동적으로 제거된다.
          지속적으로 필요한 데이터(자동 로그인 등)는 로컬 스토리지에 저장하고,
          잠깐 동안 필요한 정보(일회성 로그인 정보라든가)는 세션 스토리지에 저장하도록 한다.
          그러나 비밀번호같은 중요한 정보는 절대로 저장하면 안된다.
          왜냐하면 클라이언트 컴퓨터 브라우저에 저장하는 것이기 때문에 타인에 의해 도용당할 수 있기 때문이다.

          로컬 스토리지랑 세션 스토리지가 나오기 이전에도 브라우저에 저장소 역할을 하는 게 있었다.
          바로 쿠키인데 쿠키는 만료 기한이 있는 키-값 저장소이다.

          쿠키는 4kb 용량 제한이 있고, 매번 서버 요청마다 서버로 쿠키가 같이 전송된다.
          만약 4kb 용량 제한을 거의 다 채운 쿠키가 있다면, 요청을 할 때마다 기본 4kb의 데이터를 사용한다.
          4kb 중에는 서버에 필요하지 않은 데이터들도 있을 수 있다.
          그러므로 데이터 낭비가 발생할 수 있게 된다.
          바로 그런 데이터들을 이제 로컬 스토리지와 세션 스토리지에 저장할 수 있다.
          이 두 저장소의 데이터는 서버로 자동 전송되지 않는다.

      >> 로컬 스토리지(localStorage) <<
         로컬 스토리지는 window.localStorage에 위치한다.
         키 밸류 저장소이기 때문에 키와 밸류를 순서대로 저장하면 된다.
         값으로는 문자열, boolean, 숫자, null, undefined 등을 저장할 수 있지만,
         모두 문자열로 변환된다. 키도 문자열로 변환된다.

         localStorage.setItem('name', '이순신');
         localStorage.setItem('birth', 1994);

         localStorage.getItem('name');        // 이순신
         localStorage.getItem('birth');       // 1994 (문자열)

         localStorage.removeItem('birth');    // birth 삭제
         localStorage.getItem('birth');       // null (삭제됨)

         localStorage.clear();                // 전체 삭제

         localStorage.setItem(키, 값)으로 로컬스토리지에 저장함.
         localStorage.getItem(키)로 조회함.
         localStorage.removeItem(키)하면 해당 키가 지워지고,
         localStorage.clear()하면 스토리지 전체가 비워진다.

         localStorage.setItem('object', { userid : 'leess', name : '이순신' });
         localStorage.getItem('object');   // [object Object]
            객체는 제대로 저장되지 않고 toString 메소드가 호출된 형태로 저장된다.
            [object 생성자]형으로 저장되는 것이다.
            객체를 저장하려면 두 가지 방법이 있다.
            그냥 키-값 형식으로 풀어서 여러 개를 저장할 수도 있다.
            한 번에 한 객체를 통째로 저장하려면 JSON.stringify를 해야된다.
            객체 형식 그대로 문자열로 변환하는 것이다. 받을 때는 JSON.parse하면 된다.

         localStorage.setItem('object', JSON.stringify({ userid : 'leess', name : '이순신' }));
         JSON.parse(localStorage.getItem('object')); // { userid : 'leess', name : '이순신' }

            이와같이 데이터를 지우기 전까지는 계속 저장되어 있기 때문에
            사용자의 설정(보안에 민감하지 않은)이나 데이터들을 넣어두면 된다.

      >> 세션 스토리지(sessionStorage) <<
          세션 스토리지는 window.sessionStorage에 위치한다.
          clear, getItem, setItem, removeItem, key 등
          모든 메소드가 로컬 스토리지(localStorage)와 같다.
          단지 로컬스토리지와는 다르게 데이터가 영구적으로 보관되지는 않을 뿐이다.

      >> 로컬 스토리지(localStorage)와 세션 스토리지(sessionStorage) 에 저장된 데이터를 보는 방법 <<
          크롬인 경우 F12(개발자도구) Application 탭에 가면 Storage - LocalStorage 와 SessionStorage 가 보여진다.
          거기에 들어가서 보면 Key 와 Value 값이 보여진다.
    */

    /////////////////////////////////////////////////
});
// localStorage.setItem(키, 밸류);
// localStorage.key(키);
// localStorage.removeItem(키);
// localStorage.clear(); //모든 로컬스토리지 데이터 삭제
// localStorage.length ; //로컬스토리지에 저장된 데이터의 개수
// //로컬스토리지에 저장된 데이터를 읽어오는 함수



//
// localStorage.setItem('name', '이순신');
// localStorage.setItem('birth', 1994);
// console.log(localStorage.getItem('name')); //이순신
// console.log(localStorage.getItem('birth')); //1994
//
//
// sessionStorage.setItem('name', '홍길동');
// sessionStorage.setItem('birth', 1994);
// console.log(sessionStorage.getItem('name')); //홍길동
// console.log(sessionStorage.getItem('birth')); //1994
//
//
// localStorage.setItem("member", JSON.stringify({ userid : 'leess', name : '이순신', point : 300 }));
// console.log(typeof localStorage.getItem("member"));
// console.log(JSON.parse(localStorage.getItem("member")));
//
// localStorage.clear();
// sessionStorage.clear();
const savedId = localStorage.getItem("savedId");
$('#loginUserid').val(savedId || ''); // 로컬스토리지에 저장된 아이디가 있으면 가져오고 없으면 빈 문자열
//저장된아이디가있으면 체크박스 체크
$('input#saveid').prop('checked', !!savedId);//!!는 값의 존재유무 undefined, null, 0, '' 등은 false로 변환됨



window.LoginModule = {
    login: (loginId, loginPwd)=> loginLogic(loginId, loginPwd),
    goLogout: function() { goLogout() }
};


$('button#btnSubmit').click((e)=>{
    e.preventDefault();
    login();
});

$('input#loginPwd').on('keyup', (e)=>{
    if(e.keyCode === 13) //엔터쳤을경우
        $('button#btnSubmit').click();
});
$('input#loginUserid').on('keyup', (e)=>{
    if(e.keyCode === 13) //엔터쳤을경우
        $('button#btnSubmit').click();
})

loginLogic = (loginId, loginPwd, isRemember) =>{
    $.ajax({
        url: '/api/member/login',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            userId: loginId,
            password: loginPwd,
            rememberMe: isRemember
        }),
        success: (response) => {
            console.log(response);
            console.log(response.password);
            if(response.success){//응답 제이슨에 success 키값이 true일경우
                alert(response.message);
                if(response.changedPassword)
                    alert("비밀번호 변경한지 3개월이 지났습니다. 비밀번호를 변경해 주세요.");
                window.location.href = '/index.up';
            } else {
                alert('로그인 실패: ' + response.message);
            }
        },
        error: (xhr, status, error) => {
            alert('로그인 중 오류 발생: ' + error);
        }
    });
}

//아이디 저장은 쿠키를 사용함 여기선 걍 보내고 백에서 쿠키 처리
//로그인처리함수디이
loginCookies=()=>{


    let loginId = $('input#loginUserid').val();
    let loginPwd = $('input#loginPwd').val();

    if(loginId === '' || loginPwd === ''){
        alert('아이디와 비밀번호를 입력해주세요.');
        return;
    }


    loginLogic(loginId, loginPwd);
}

//로그인처리함수디이 로컬스토리지에 담기
login=()=>{
    const loginId = $('input#loginUserid').val();
    const loginPwd = $('input#loginPwd').val();

    if(loginId === '' || loginPwd === ''){
        alert('아이디와 비밀번호를 입력해주세요.');
        return;
    }
    const isRemember = $('input#saveid').is(':checked'); // 체크박스 상태 확인
    if(isRemember)
        localStorage.setItem("savedId", loginId);
    else
        localStorage.removeItem("savedId");


    loginLogic(loginId, loginPwd, isRemember);
}
//로그아웃처리 함수디이
goLogout=()=>{
    $.ajax({
        url: '/api/member/logout',
        type: 'POST',
        success: (response) => {
            if(response.success){
                alert(response.message);
                window.location.href = '/index.up';
            } else {
                alert('로그아웃 실패: ' + response.message);
            }
        },
        error: (xhr, status, error) => {
            alert('로그아웃 중 오류 발생: ' + error);
        }
    });
}
//코인충전 코인충전 결제금액 선택하기(실제로 카드 결제)
goCoinPurchaseTypeChoice = (userId, ctxPath)=> {
    console.log(userId);
    console.log(ctxPath);
    //충전 금액 선택하기 팝업창 띄우기
    //팝업창 크기 정해노코 가운데 위치시키기
    const width = 650;
    const height = 570;

    const left = Math.ceil( (window.screen.width - width) / 2 ); //화면의 너비
    const top = Math.ceil((window.screen.height - height) / 2); //화면의 높이

    const url = ctxPath + '/member/coinPurchaseTypeChoice.up?userId=' + userId;
    window.open(url, 'coinPurchaseTypeChoice', `left=${left}, top=${top}, width=${width}, height=${height}`);

}

//코인충전 코인충전 결제금액 선택하기(실제로 카드 결제)
goPaymentStart = (ctxPath, userId, coin, point)=> {

    // alert('확인 ' + ctxPath + ' ' + userId + ' ' + coin + ' ' + point);
    const url = ctxPath + '/member/coinPayment.up?userId=' + userId + '&coin=' + coin + '&point=' + point;
    const width = 1000;
    const height = 600;
    const left = Math.ceil( (window.screen.width - width) / 2 ); //화면의 너비
    const top = Math.ceil((window.screen.height - height) / 2); //화면의 높이
    window.open(url, 'coinPayment', `left=${left}, top=${top}, width=${width}, height=${height}`);


    // console.log(userId);
    // console.log(ctxPath);
    // //충전 금액 선택하기 팝업창 띄우기
    // //팝업창 크기 정해노코 가운데 위치시키기
    // const width = 650;
    // const height = 570;
    //
    // const left = Math.ceil( (window.screen.width - width) / 2 ); //화면의 너비
    // const top = Math.ceil((window.screen.height - height) / 2); //화면의 높이
    //
    // const url = ctxPath + '/member/coinPurchaseTypeChoice.up?userId=' + userId;
    // window.open(url, 'coinPurchaseTypeChoice', `left=${left}, top=${top}, width=${width}, height=${height}`);

}

goCoinUpdate = (ctxPath, userId, coin, point) => {

    //코인충전 업데이트
    alert('성공후 진행창  ' + coin + ' ' + point);
    axios.put('/api/member/coin', {
        userId: userId,
        coinAmount: coin,
        pointAmount: point
    }).then((response) => {
        if(response.data.success){
            alert('코인 충전이 완료되었습니다. 충전된 코인: ' + response.data.success.responseData.coinAmount + ', 포인트: ' + response.data.success.responseData.pointAmount);
            alert('현재 코인: ' + response.data.success.responseData.currentCoin + ', 현재 포인트: ' + response.data.success.responseData.currentPoint);
            window.location.href = ctxPath + '/index.up';
        } else {
            alert('코인 충전 실패: ' + response.data.message);
            //TODO:결제 취소 로직 써야됨 우린 없음
            javaScript:history.back();
        }
    }).catch((error) => {
        console.error('코인 충전 중 오류 발생:', error);
        // 200번대가 아닌 응답(에러) 처리
        if (error.response) {
            alert('서버 오류: ' + error.response.status + '\n' + (error.response.data.message || '잠시 후 다시 시도해주세요.'));
        } else {
            alert('요청 실패: ' + error.message);
        }
        //TODO: 결제 취소 로직 써야됨 우린 없음

        history.back();
    });


}





// 아이디 찾기 모달 닫기 버튼 클릭 이벤트
const idFindClose = $('.idFindClose');
idFindClose.click(function () {
    // <%-- 선택자를 잡을때 jQuery를 사용한 ${} 으로 잡으면 안되고, 순수한 자바스크립트를 사용하여 선택자를 잡아야 한다. --%>
    // <%-- .jsp 파일속에 주석문을 만들때 ${} 을 넣고자 한다라면 반드시 JSP 주석문으로 해야 하지, 스크립트 주석문으로 해주면 ${} 때문에 오류가 발생한다. --%>
    document.getElementById("iframe_idFind").contentWindow.idFindCloseEvent();
    //자식요소의 함수호출
});
// 비밀번호 찾기 모달 닫기 버튼 클릭 이벤트
const passwdFindClose = $('.passwdFindClose');
passwdFindClose.click(()=>{
    document.getElementById("iframe_pwdFind").contentWindow.pwdFindCloseEvent();
})

//회원정보수정
goEditMyInfo = (userId,ctxPath) => {
    // 나의정보 수정하기 팝업창 띄우기
    const url = `${ctxPath}/member/memberEdit.up?userid=${userId}`;
//  또는
//  const url = ctx_Path+"/member/memberEdit.up?userid="+userid;

    // 너비 800, 높이 680 인 팝업창을 화면 가운데 위치시키기
    const width = 800;
    const height = 680;
    /*
       console.log("모니터의 넓이 : ",window.screen.width);
       // 모니터의 넓이 :  1440

       console.log("모니터의 높이 : ",window.screen.height);
       // 모니터의 높이 :  900
    */
    const left = Math.ceil((window.screen.width - width)/2);  // 정수로 만듬
    const top = Math.ceil((window.screen.height - height)/2); // 정수로 만듬
    window.open(url, "myInfoEdit",
        `left=${left}, top=${top}, width=${width}, height=${height}`);


}