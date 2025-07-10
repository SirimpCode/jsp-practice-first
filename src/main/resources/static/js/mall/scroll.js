// HIT 상품 게시물을 더보기 위하여 스크롤 액션 이벤트 등록하기
// 스크롤 이벤트

let hitPage = 1; // HIT상품 게시물 페이지 초기값
// HIT상품 게시물을 더보기 위하여 "더보기..." 버튼 클릭액션에 대한 초기값 호출하기
// 즉, 맨처음에는 "더보기..." 버튼을 클릭하지 않더라도 클릭한 것 처럼 8개의 HIT상품을 게시해주어야 한다는 말이다.

// start가  1 이라면   1~ 8  까지 상품 8개를 보여준다.
// start가  9 이라면   9~ 16  까지 상품 8개를 보여준다.
// start가 17 이라면  17~ 24  까지 상품 8개를 보여준다.
// start가 25 이라면  25~ 32  까지 상품 8개를 보여준다.
// start가 33 이라면  33~ 36  까지 상품 4개를 보여준다.(마지막 상품)$(window).on('scroll', function() {
//     // 스크롤 위치 + 창 높이 >= 문서 전체 높이 - 여유분(100px 정도)
//     if ($(window).scrollTop() + $(window).height() >= $(document).height() - 100) {
//         loadMoreProducts();
//     }
// });

let currentCategory = 'hit'; // 현재 선택된 카테고리
let currentSort = 'newest'; // 현재 선택된 정렬 방식
let currentPage = 1; // 현재 페이지
let currentPageSize = 8; // 페이지당 상품 수
let isLoading = false;
//카테고리와 정렬
const categories = document.querySelectorAll('.category');
const sortSelect = document.querySelector('.sort-box select');

categories.forEach(category => {
    category.addEventListener('click', () => {
        const selectedCategory = category.dataset.category;
        if (currentCategory === selectedCategory) return;
        categories.forEach(c => c.classList.remove('active'));
        category.classList.add('active');
        currentPage = 1; // Reset to first page on category change
        currentSort = 'newest'; // Reset sort to default on category change
        sortSelect.selectedIndex = 0; // Reset sort select to first option
        currentCategory = selectedCategory;
        registerScrollEvent();//스크롤이벤트 부활
        requestByParams();
        // searchProductList();
        // registerScrollEvent();

    });
});
sortSelect.addEventListener('change', function () {
    const selectedOption = this.options[this.selectedIndex];
    const sortValue = selectedOption.dataset.sort;
    if (!sortValue || sortValue === currentSort) return;

    currentPage = 1; // Reset to first page on sort change
    currentSort = sortValue;
    registerScrollEvent();//스크롤이벤트 부활
    requestByParams();
    // searchProductList();
    // registerScrollEvent();
});

// 스크롤 이벤트 콜백 함수 분리
function onScrollLoad() {
    if ($(window).scrollTop() + $(window).height() >= $(document).height() - 100) {
        requestByParams();
    }
}

// 스크롤 이벤트 등록 함수
function registerScrollEvent() {
    $(window).off('scroll', onScrollLoad); // 중복 방지
    $(window).on('scroll', onScrollLoad);
}



requestByParams = () => {
    if(isLoading) return; // 이미 로딩 중이면 중복 요청 방지
    isLoading = true; // 로딩 상태 설정
    const params = {
        page: currentPage,
        category: currentCategory,
        sort: currentSort,
        pageSize: currentPageSize
    }
    axios.get(`/api/mall`, { params })
        .then(response =>{
            console.log(response)

            if(currentPage===1 && !response.data.success.responseData){
                $('#displayHIT').html('<p>등록된 HIT 상품이 없습니다.</p>');
                $(window).off('scroll');
                isLoading = false; // 로딩 상태 해제
                return;
            }
            if(!response.data.success.responseData){
                isLoading = false; // 로딩 상태 해제
                return
            }


            const lastPage = response.data.success.responseData.totalPages;
            if(lastPage === currentPage) {
                $(window).off('scroll');
            }

            if(currentPage === 1)
                $container.empty(); // 첫 페이지 로딩 시 기존 내용 초기화
            displayProducts(response.data.success.responseData.items)
            currentPage++; // 다음 페이지로 이동
        })
        .catch(error => {
            console.error("Error fetching HIT products:", error);
        }).finally(()=>isLoading = false) // 로딩 상태 해제)

}
//
//
// function displayHIT(page) {
//     const params = {
//         page: page,
//         category : currentCategory
//     }
//     axios.get(`/api/mall`, { params })
//         .then(response =>{
//             if(page===1 && !response.data.success.responseData){
//                 $('#displayHIT').html('<p>등록된 HIT 상품이 없습니다.</p>');
//                 $(window).off('scroll');
//                 return;
//             }
//             if(!response.data.success.responseData)
//                 return
//
//             const lastPage = response.data.success.responseData.totalPages;
//             if(lastPage === page) {
//                 $(window).off('scroll');
//             }
//
//
//             displayProducts(response.data.success.responseData.items)
//         })
//         .catch(error => {
//             console.error("Error fetching HIT products:", error);
//         })
//
//
//     hitPage++;
//
// }
const $container = $("#displayHIT");
function displayProducts(products) {

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
                    <img src="${product.productImage1}" class="card-img-top" alt="${product.productName}">
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
    location.href = `/product/detail/${productId}`;
});

// 초기 로딩 시 HIT 상품 표시
requestByParams();
registerScrollEvent(); //초기 이벤트등록