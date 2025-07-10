<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 25. 7. 7.
  Time: 오전 9:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String ctxPath = request.getContextPath();
%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<jsp:include page="../header1.jsp" />

<style type="text/css">
  .highcharts-figure,
  .highcharts-data-table table {
    min-width: 320px;
    max-width: 800px;
    margin: 1em auto;
  }

  .highcharts-data-table table {
    font-family: Verdana, sans-serif;
    border-collapse: collapse;
    border: 1px solid #ebebeb;
    margin: 10px auto;
    text-align: center;
    width: 100%;
    max-width: 500px;
  }

  .highcharts-data-table caption {
    padding: 1em 0;
    font-size: 1.2em;
    color: #555;
  }

  .highcharts-data-table th {
    font-weight: 600;
    padding: 0.5em;
  }

  .highcharts-data-table td,
  .highcharts-data-table th,
  .highcharts-data-table caption {
    padding: 0.5em;
  }

  .highcharts-data-table thead tr,
  .highcharts-data-table tr:nth-child(even) {
    background: #f8f8f8;
  }

  .highcharts-data-table tr:hover {
    background: #f1f7ff;
  }

  input[type="number"] {
    min-width: 50px;
  }

</style>

<script src="<%=ctxPath%>/Highcharts-10.3.1/code/highcharts.js"></script>
<script src="<%=ctxPath%>/Highcharts-10.3.1/code/modules/exporting.js"></script>
<script src="<%=ctxPath%>/Highcharts-10.3.1/code/modules/export-data.js"></script>
<script src="<%=ctxPath%>/Highcharts-10.3.1/code/modules/accessibility.js"></script>

<script src="<%=ctxPath%>/Highcharts-10.3.1/code/modules/series-label.js"></script>


<div style="display: flex;">
  <div style="width: 80%; min-height: 1100px; margin:auto; ">

    <h2 style="margin: 50px 0;">${sessionScope.loginuser.userName} 님의 주문통계 차트</h2>

    <form name="searchFrm" style="margin: 20px 0 50px 0; ">
      <select name="searchType" id="searchType" style="height: 40px;">
        <option value="">통계선택하세요</option>
        <option value="myPurchase_byCategory">나의 카테고리별주문 통계</option>
        <option value="myPurchase_byMonth_byCategory">나의 카테고리별 월별주문 통계</option>
      </select>
    </form>

    <div id="chart_container"></div>
    <div id="table_container" style="margin: 40px 0 0 0;"></div>

  </div>
</div>




<script>
  const statistics = JSON.parse('${fn:replace(statistics, "\\", "\\\\")}');
  console.log(statistics);
  const productsStatistics = JSON.parse('${fn:replace(productStatistics, "\\", "\\\\")}');
  console.log(productsStatistics);

  $(function(){
    $('select#searchType').change(function(e){
      funcChoice($(e.target).val());
    })
  })
  function funcChoice(searchType){
    let resultArr = [];
    switch (searchType){
      case "myPurchase_byMonth_byCategory":
        viewChartMonth();
        break;
      case "myPurchase_byCategory":
        viewChart();
        break;
    }
  }
  function  viewChartMonth(){
    Highcharts.chart('chart_container', {

      title: {
        text: '월별 통계'
      },

      subtitle: {
        text: 'Source: <a href="https://irecusa.org/programs/solar-jobs-census/" target="_blank">IREC</a>'
      },

      yAxis: {
        title: {
          text: 'Number of Employees'
        }
      },

      xAxis: {
        accessibility: {
          rangeDescription: 'Range: 1 to 12'
        }
      },

      legend: {
        layout: 'vertical',
        align: 'right',
        verticalAlign: 'middle'
      },

      plotOptions: {
        series: {
          label: {
            connectorAllowed: false
          },
          pointStart: 1
        }
      },

      series: productsStatistics,

      responsive: {
        rules: [{
          condition: {
            maxWidth: 500
          },
          chartOptions: {
            legend: {
              layout: 'horizontal',
              align: 'center',
              verticalAlign: 'bottom'
            }
          }
        }]
      }

    });
  }
  function viewChart() {
    Highcharts.chart('chart_container', {
      chart: {
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        type: 'pie'
      },
      title: {
        text: '나의 주문통계'
      },
      tooltip: {
        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
      },
      accessibility: {
        point: {
          valueSuffix: '%'
        }
      },
      plotOptions: {
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: true,
            format: '<b>{point.name}</b>: {point.percentage:.1f} %'
          }
        }
      },
      series: [{
        name: 'Brands',
        colorByPoint: true,
        data: statistics
      }]
    });
  }

</script>


<jsp:include page="../footer1.jsp" />
