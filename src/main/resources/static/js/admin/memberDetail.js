if (!userIdParam) {
    alert("사용자 ID가 제공되지 않았습니다.");
    history.back(); // 이전 페이지로 돌아가기
}
$("div#smsResult").hide()
function putMemberDetail(responseData){
    const userDetail = responseData.success.responseData;
    const userId = userDetail.userId;
    const userName = userDetail.userName;
    const email = userDetail.email;
    const phoneNumber = userDetail.phoneNumber;
    const zipCode = userDetail.zipCode;
    const address = userDetail.address;
    const gender = userDetail.gender;
    const birthDay = userDetail.birthDay;
    const coin = userDetail.coin;
    const age = userDetail.age;
    const point = userDetail.point;
    const registerAt = userDetail.registerAt;
    document.getElementById('detailTitle').innerText = `::: ${userName}(${userId}) 님의 정보 :::`;
    document.getElementById('userIdInput').innerText = userId;
    document.getElementById('userNameInput').innerText = userName;
    document.getElementById('emailInput').innerText = email;
    document.getElementById('phoneNumberInput').innerText = phoneNumber;
    document.getElementById('zipCodeInput').innerText = zipCode;
    document.getElementById('addressInput').innerText = address;
    document.getElementById('genderInput').innerText = gender;
    document.getElementById('birthInput').innerText = birthDay;
    document.getElementById('ageInput').innerText = age;
    document.getElementById('coinInput').innerText = coin;
    document.getElementById('pointInput').innerText = point;
    document.getElementById('registerAtInput').innerText = registerAt;
}

axios.get(`/api/admin/member/${userIdParam}`)
    .then(response =>{
        console.log(response.data);
        putMemberDetail(response.data);
    })
    .catch(error => {
        console.error("Error fetching member details:", error);
    })

$('button#btnSend').click(()=>{
    console.log($('input[type="date"]#reservedate').val() + " " + $('input[type="time"]#reservetime').val());

    const date = $('input[type="date"]#reservedate').val();      // 예: 2025-06-17
    const time = $('input[type="time"]#reservetime').val();      // 예: 09:24

    const today = new Date();//현재시간
    const pad = n => n.toString().padStart(2, '0');//한자리 숫자일때 0을 앞에 붙임 5 -> 05
    //오늘 날짜 yyyy-mm-dd 형식으로 월은 0부터 시작하므로 +1 해줘야함
    const defaultDate = `${today.getFullYear()}-${pad(today.getMonth() + 1)}-${pad(today.getDate())}`;

    const reservedDateTime = `${date || defaultDate}T${time || '00:00'}`;

    const smsContent = $('#smsContent').val();
    const phoneNumber = $('#phoneNumberInput').text().trim();

    axios.post('/api/message/send', {
        reservedDateTime: reservedDateTime,
        message: smsContent,
        phoneNumber: phoneNumber
    })
        .then(response => {
            console.log(response)
            $("div#smsResult").html("<span style='color:red; font-weight:bold;'>문자전송이 성공되었습니다.^^</span>");
            // 성공 처리
        })
        .catch(error => {
            // 에러 처리

            console.error("Error sending SMS:", error);
            $("div#smsResult").html("<span style='color:red; font-weight:bold;'>문자전송이 실패하였습니다.ㅋㅋ</span>");
        });
    $("div#smsResult").show()
    smsContent.val("")


})