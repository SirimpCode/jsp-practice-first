$(()=>{})
// HIT 상품 게시물을 더보기 위하여 "더보기..." 버튼 클릭액션 이벤트 등록하기
$('button#btnMoreHIT').click(()=>{
    displayHIT(hitPage);
})// HIT 상품 게시물을 더보기 위하여 "더보기..." 버튼 클릭액션 이벤트 등록하기
let hitPage = 1; // HIT상품 게시물 페이지 초기값
// HIT상품 게시물을 더보기 위하여 "더보기..." 버튼 클릭액션에 대한 초기값 호출하기
// 즉, 맨처음에는 "더보기..." 버튼을 클릭하지 않더라도 클릭한 것 처럼 8개의 HIT상품을 게시해주어야 한다는 말이다.
displayHIT(hitPage);
// start가  1 이라면   1~ 8  까지 상품 8개를 보여준다.
// start가  9 이라면   9~ 16  까지 상품 8개를 보여준다.
// start가 17 이라면  17~ 24  까지 상품 8개를 보여준다.
// start가 25 이라면  25~ 32  까지 상품 8개를 보여준다.
// start가 33 이라면  33~ 36  까지 상품 4개를 보여준다.(마지막 상품)


function displayHIT(page) {
    const params = {
        page: page,
        specName : 'HIT'
    }
    axios.get(`/api/mall`, { params })
        .then(response =>{
            if(page===1 && !response.data.success.responseData){
                $('#displayHIT').html('<p>등록된 HIT 상품이 없습니다.</p>');
                $('#btnMoreHIT').hide();
                return;
            }
            if(!response.data.success.responseData)
                return
            const lastPage = response.data.success.responseData.totalPages;
            if(lastPage === page) {
                $('#btnMoreHIT').hide(); // 마지막 페이지라면 "더보기..." 버튼 숨기기
                $('#btnFirst').show(); // "처음으로" 버튼 보이기
            }

            displayProducts(response.data.success.responseData.items)
        })
        .catch(error => {
            console.error("Error fetching HIT products:", error);
        })


    hitPage++;

}

$('#btnFirst').click(()=>{
    hitPage = 1; // 페이지 초기화
    $('#btnMoreHIT').show(); // "더보기..." 버튼 보이기
    $('#btnFirst').hide(); // "처음으로" 버튼 숨기기
    $('div#displayHIT').empty(); // 기존 내용 초기화
    displayHIT(hitPage); // 처음부터 다시 불러오기
})
function displayProducts(products) {
    const $container = $("#displayHIT");
    // $container.empty(); // 초기화

    let $row = null;

    $.each(products, function(index, product) {
        // 4개마다 새로운 row
        if (index % 4 === 0) {
            $row = $('<div class="row mb-4"></div>');
            $container.append($row);
        }

        const $card = $(`
            <div class="col-md-3">
                <div class="card h-100 card-hover" data-product-id="${product.productId}">
                    <img src="/images/${product.productImage1}" class="card-img-top" alt="${product.productName}">
                    <div class="card-body">
                        <h5 class="card-title">${product.productName}</h5>
                        <p class="card-text">
                            <del>${product.price.toLocaleString()}원</del><br>
                            <strong>${product.salePrice.toLocaleString()}원</strong><br>
                            <span class="text-danger">[${product.salePercentage}% 할인]</span><br>
                            <span class="text-warning">${product.productPoint} POINT</span>
                        </p>
                        <a class="btn btn-outline-primary">자세히보기</a>
                    </div>
                </div>
            </div>
        `);

        $row.append($card);
    });
}
// 이벤트 위임 방식
$('#displayHIT').on('click', '.card', function () {
    const productId = $(this).data('product-id');
    console.log("클릭된 상품 ID:", productId);
    // 예: location.href = `/product/detail/${productId}`;
});

