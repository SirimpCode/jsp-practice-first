package com.github.mymvcspring.repository.product;

import com.github.mymvcspring.repository.user.QMyUser;
import com.github.mymvcspring.web.dto.PaginationDto;
import com.github.mymvcspring.web.dto.ProductStatisticsResponse;
import com.github.mymvcspring.web.dto.StatisticsResponse;
import com.github.mymvcspring.web.dto.product.ProductListRequest;
import com.github.mymvcspring.web.dto.product.ProductListResponse;
import com.github.mymvcspring.web.dto.product.ProductRegisterRequest;
import com.querydsl.core.types.ExpressionUtils;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@RequiredArgsConstructor
public class ProductRepositoryCustomImpl implements ProductRepositoryCustom {
    private final JPAQueryFactory queryFactory;

    @Override
    public long countAllProductsBySpecName(String specName) {
        Long count = queryFactory.select(QProduct.product.count())
                .from(QProduct.product)
                .where(QProduct.product.productSpec.productSpecName.eq(specName))
                .fetchOne();
        return count != null ? count : 0L;
    }


    @Override
    public PaginationDto<ProductListResponse> findAllByCategoryOrderBySort(ProductListRequest request) {
        long page = request.getPage(); // 페이지는 1부터 시작하므로 0으로 조정
        long size = request.getSize(); // 페이지당 아이템 수

        BooleanExpression whereClause = whereClauseByCategoryOrSpec(request.getCategory());
        OrderSpecifier<?>[] orderSpecifier = orderByCreate(request.getSort());
        long totalCount = countAllProductsByCategoryOrSpec(whereClause);

        long lastPage = //딱 나누어 떨어지면 나누기만 하면 되고, 나누어 떨어지지 않으면 +1을 해줘야 한다.
                (totalCount % size == 0) ? (totalCount / size) : (totalCount / size + 1);
        List<ProductListResponse> productListResponses = queryFactory.select(
                        Projections.fields(
                                ProductListResponse.class,
                                QProduct.product.productId,
                                QProduct.product.productName,
                                QProduct.product.price,
                                QProduct.product.salePrice,
                                QProduct.product.productImage1,
                                QProduct.product.productImage2,
                                QProduct.product.productPoint
                        )
                ).from(QProduct.product)
                .where(whereClause)
                .orderBy(orderSpecifier)
                .offset(page * size)
                .limit(size)
                .fetch();


        return PaginationDto.of(
                page + 1, // 페이지는 1부터 시작하므로 +1
                size,
                lastPage, // 마지막 페이지
                totalCount, // 전체 아이템 수
                productListResponses // 현재 페이지의 아이템 리스트
        );
    }

    @Override
    public List<StatisticsResponse> statisticsByCategory() {
        return queryFactory.select(
                        Projections.fields(
                                StatisticsResponse.class,
                                QProduct.product.category.categoryName.as("name"),
                                QProduct.product.count().as("count")
                        )
                ).from(QProduct.product)
                .groupBy(QProduct.product.category.categoryName)
                .fetch();
    }

    @Override
    public ProductStatisticsResponse statisticsByMonthRegistration() {
        List<Long> productCountByMonth = queryFactory.select(
                        QProduct.product.count()
                ).from(QProduct.product)
                .where(QProduct.product.createdAt.month().eq(LocalDate.now().getMonthValue()-1))
                .groupBy(QProduct.product.createdAt.dayOfMonth())
                .orderBy(QProduct.product.createdAt.dayOfMonth().asc())
                .fetch();
        //월별 상품 통계 조회
        return ProductStatisticsResponse.of(
                "월별 상품 통계",
                productCountByMonth
        );
    }

    @Override
    public ProductStatisticsResponse statisticsByMonthUser() {
        List<Long> userCountByMonth = queryFactory.select(
                        QMyUser.myUser.count()
                ).from(QMyUser.myUser)
                .where(QMyUser.myUser.registerAt.month().eq(LocalDate.now().getMonthValue()-1))
                .groupBy(QMyUser.myUser.registerAt.dayOfMonth())
                .orderBy(QMyUser.myUser.registerAt.dayOfMonth().asc())
                .fetch();
        return ProductStatisticsResponse.of(
                "회원 가입 통계",
                userCountByMonth
        );
//        return queryFactory.select(
//                        Projections.fields(
//                                ProductStatisticsResponse.class,
//                                ExpressionUtils.as(Expressions.constant("회원가입갯수"), "name"),
//                                QMyUser.myUser.count().as("count")
//                        ))
//                .from(QMyUser.myUser)
//                .groupBy(QMyUser.myUser.registerAt.month())
//                .orderBy(QMyUser.myUser.registerAt.month().asc())
//                .fetch();
    }
    @Override
    public ProductStatisticsResponse statisticsByMonthProductPrice(){
        //월별 상품 가격 통계 조회
        List<Long> productPriceByMonth = queryFactory.select(
                        QProduct.product.price.sumLong()
                ).from(QProduct.product)
                .where(QProduct.product.createdAt.month().eq(LocalDate.now().getMonthValue()-1))
                .groupBy(QProduct.product.createdAt.dayOfMonth())
                .orderBy(QProduct.product.createdAt.dayOfMonth().asc())
                .fetch();
        return ProductStatisticsResponse.of(
                "월별 상품 가격 통계",
                productPriceByMonth
        );
    }

    private OrderSpecifier<?>[] orderByCreate(ProductListRequest.Sort sort) {
        return switch (sort) {
            //가격순 우선정렬 이후 가격이 같다면 productId로 정렬
            case PRICE_ASC -> new OrderSpecifier<?>[]{
                    QProduct.product.price.asc().nullsLast(),
                    QProduct.product.productId.asc()
            };
            case PRICE_DESC -> new OrderSpecifier<?>[]{
                    QProduct.product.price.desc().nullsLast(),
                    QProduct.product.productId.asc()
            };
            case NEWEST -> new OrderSpecifier<?>[]{
                    QProduct.product.createdAt.desc(),
                    QProduct.product.productId.asc()

            };
            case OLDEST -> new OrderSpecifier<?>[]{
                    QProduct.product.createdAt.asc(),
                    QProduct.product.productId.asc()
            };
        };
    }

    private long countAllProductsByCategoryOrSpec(BooleanExpression whereClause) {
        Long count = queryFactory.select(QProduct.product.count())
                .from(QProduct.product)
                .where(whereClause)
                .fetchOne();
        return count != null ? count : 0L;
    }

    private BooleanExpression whereClauseByCategoryOrSpec(ProductListRequest.Category category) {
        if (category == null || category == ProductListRequest.Category.ALL)
            return null; // 전체 카테고리인 경우 조건 없음
        return switch (category) {
            case ELECTRONIC, CLOTHING, BOOK -> QProduct.product.category.categoryName.eq(category.getValue());
            case HIT -> QProduct.product.productSpec.productSpecId.eq(Long.parseLong(category.getValue()));
            default -> throw new IllegalStateException("Unexpected value: " + category);
        };

    }


    @Override
    public PaginationDto<ProductListResponse> findAllProductsBySpecName(long page, String specName) {
        long size = 8; // Assuming a fixed size of 8 items per page
        List<ProductListResponse> productListResponses = queryFactory.select(
                        Projections.fields(
                                ProductListResponse.class,
                                QProduct.product.productId,
                                QProduct.product.productName,
                                QProduct.product.price,
                                QProduct.product.salePrice,
                                QProduct.product.productImage1,
                                QProduct.product.productImage2,
                                QProduct.product.productPoint
                        )
                ).from(QProduct.product)
                .where(QProduct.product.productSpec.productSpecName.eq(specName))
                .offset(page * size)
                .limit(size)
                .fetch();
        long totalCount = countAllProductsBySpecName(specName);
        long lastPage = //딱 나누어 떨어지면 나누기만 하면 되고, 나누어 떨어지지 않으면 +1을 해줘야 한다.
                (totalCount % size == 0) ? (totalCount / size) : (totalCount / size + 1);
        return PaginationDto.of(
                page + 1, // 페이지는 1부터 시작하므로 +1
                size,
                lastPage, // 마지막 페이지
                totalCount, // 전체 아이템 수
                productListResponses // 현재 페이지의 아이템 리스트
        );
    }
}
