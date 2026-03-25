/* adHome.js */

document.addEventListener("DOMContentLoaded", function () {
    const startInput = document.getElementById("startDate");
    const endInput = document.getElementById("endDate");
    const rangeButtons = document.querySelectorAll(".range-btn");

    // -------------------------------------------------
    // 공통 유틸
    // -------------------------------------------------
    function formatDate(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, "0");
        const day = String(date.getDate()).padStart(2, "0");
        return `${year}-${month}-${day}`;
    }

    function clearActiveButtons() {
        rangeButtons.forEach(btn => btn.classList.remove("active"));
    }

    // 오늘 포함 N일 범위의 시작일 계산
    function getStartDateByRange(days) {
        const today = new Date();
        const start = new Date(today);
        start.setDate(today.getDate() - (days - 1));
        return formatDate(start);
    }

    // -------------------------------------------------
    // 기간 버튼 active 처리
    // -------------------------------------------------
    function syncActiveButton() {
        if (!startInput || !endInput || rangeButtons.length === 0) {
            return;
        }

        const currentStart = startInput.value;
        const currentEnd = endInput.value;

        clearActiveButtons();

        if (!currentStart || !currentEnd) {
            return;
        }

        const todayStr = formatDate(new Date());

        // 종료일이 오늘이 아니면 직접 기간 조회로 판단
        if (currentEnd !== todayStr) {
            return;
        }

        rangeButtons.forEach(btn => {
            const days = Number(btn.dataset.range);
            const expectedStart = getStartDateByRange(days);

            if (currentStart === expectedStart) {
                btn.classList.add("active");
            }
        });
    }

    if (rangeButtons.length > 0 && startInput && endInput) {
        rangeButtons.forEach(btn => {
            btn.addEventListener("click", function (event) {
                event.preventDefault();

                const days = Number(this.dataset.range);
                const todayStr = formatDate(new Date());
                const startStr = getStartDateByRange(days);

                startInput.value = startStr;
                endInput.value = todayStr;

                clearActiveButtons();
                this.classList.add("active");
            });
        });

        syncActiveButton();
    }

    // -------------------------------------------------
    // 서버에서 내려준 데이터
    // JSP의 window.adminHomeData 사용
    // -------------------------------------------------
    if (!window.adminHomeData) {
        return;
    }

    const trendList = window.adminHomeData.trendList || [];
    const npsDistribution = window.adminHomeData.npsDistribution || [];
    const today = window.adminHomeData.today || "";
    const trafficTrendList = window.adminHomeData.trafficTrendList || [];

    // -------------------------------------------------
    // 최근 만족도 차트
    // - JSP id : trendChart
    // -------------------------------------------------
    const trendDates = trendList.map(item => item.statDate);
    const satisfactionData = trendList.map(item => item.satisfactionAvg);
    const infoReliabilityData = trendList.map(item => item.infoReliabilityAvg);
    const npsTrendData = trendList.map(item => item.npsAvg);

    const todayIndex = trendDates.indexOf(today);

    const trendChartEl = document.getElementById("trendChart");
    if (trendChartEl) {
        const trendChart = echarts.init(trendChartEl);

        trendChart.setOption({
            tooltip: { trigger: "axis" },
            legend: {
                top: 10,
                data: ["맛집만족도", "정보신뢰도", "NPS"]
            },
            grid: {
                left: "4%",
                right: "4%",
                top: "18%",
                bottom: "8%",
                containLabel: true
            },
            xAxis: {
                type: "category",
                data: trendDates,
                axisLine: {
                    lineStyle: {
                        color: "#cfd8e3"
                    }
                },
                axisLabel: {
                    color: "#6b7785"
                }
            },
            yAxis: {
                type: "value",
                axisLine: { show: false },
                splitLine: {
                    lineStyle: {
                        color: "#eef2f7"
                    }
                },
                axisLabel: {
                    color: "#6b7785"
                }
            },
            series: [
                {
                    name: "맛집만족도",
                    type: "line",
                    data: satisfactionData,
                    smooth: true,
                    symbol: "circle",
                    symbolSize: 6,
                    markPoint: todayIndex > -1 ? {
                        data: [{
                            coord: [trendDates[todayIndex], satisfactionData[todayIndex]],
                            name: "오늘"
                        }]
                    } : {}
                },
                {
                    name: "정보신뢰도",
                    type: "line",
                    data: infoReliabilityData,
                    smooth: true,
                    symbol: "circle",
                    symbolSize: 6,
                    markPoint: todayIndex > -1 ? {
                        data: [{
                            coord: [trendDates[todayIndex], infoReliabilityData[todayIndex]],
                            name: "오늘"
                        }]
                    } : {}
                },
                {
                    name: "NPS",
                    type: "line",
                    data: npsTrendData,
                    smooth: true,
                    symbol: "circle",
                    symbolSize: 6,
                    markPoint: todayIndex > -1 ? {
                        data: [{
                            coord: [trendDates[todayIndex], npsTrendData[todayIndex]],
                            name: "오늘"
                        }]
                    } : {}
                }
            ]
        });

        window.addEventListener("resize", function () {
            trendChart.resize();
        });
    }

    // -------------------------------------------------
    // NPS 평점 분포
    // - JSP id : npsChart
    // -------------------------------------------------
    const npsChartEl = document.getElementById("npsChart");
    if (npsChartEl) {
        const pieData = npsDistribution.map(item => {
            let color = "#10b981";
            if (item.bucketName === "Detractor") color = "#ef4444";
            else if (item.bucketName === "Passive") color = "#f59e0b";

            return {
                value: item.scoreCount,
                name: item.bucketName,
                itemStyle: { color: color }
            };
        });

        const npsChart = echarts.init(npsChartEl);

        npsChart.setOption({
            tooltip: {
                trigger: "item",
                formatter: function (params) {
                    const matched = npsDistribution.find(item => item.bucketName === params.name);
                    const ratioText = matched ? ` (${matched.ratio}%)` : "";
                    return `${params.name}<br/>${params.value}건${ratioText}`;
                }
            },
            legend: {
                bottom: 0
            },
            series: [
                {
                    name: "NPS 분포",
                    type: "pie",
                    radius: ["40%", "70%"],
                    center: ["50%", "42%"],
                    avoidLabelOverlap: false,
                    label: {
                        show: true,
                        formatter: "{b}\n{d}%"
                    },
                    data: pieData
                }
            ]
        });

        window.addEventListener("resize", function () {
            npsChart.resize();
        });
    }

    // -------------------------------------------------
    // GA 기간별 트래픽 추이
    // - JSP id : trafficTrendChart
    // - window.adminHomeData.trafficTrendList 사용
    // -------------------------------------------------
    const trafficDates = trafficTrendList.map(item => item.date);
    const visitorSeries = trafficTrendList.map(item => item.visitorCount);
    const viewSeries = trafficTrendList.map(item => item.viewCount);

    const trafficTrendChartEl = document.getElementById("trafficTrendChart");
    if (trafficTrendChartEl) {
        const trafficTrendChart = echarts.init(trafficTrendChartEl);

        const trafficTrendOption = {
            tooltip: {
                trigger: "axis"
            },
            legend: {
                top: 10,
                data: ["방문자 수", "페이지뷰"]
            },
            grid: {
                left: "4%",
                right: "4%",
                top: "18%",
                bottom: "8%",
                containLabel: true
            },
            xAxis: {
                type: "category",
                boundaryGap: false,
                data: trafficDates,
                axisLine: {
                    lineStyle: {
                        color: "#cfd8e3"
                    }
                },
                axisLabel: {
                    color: "#6b7785"
                }
            },
            yAxis: {
                type: "value",
                axisLine: {
                    show: false
                },
                splitLine: {
                    lineStyle: {
                        color: "#eef2f7"
                    }
                },
                axisLabel: {
                    color: "#6b7785"
                }
            },
            series: [
                {
                    name: "방문자 수",
                    type: "line",
                    smooth: true,
                    symbol: "circle",
                    symbolSize: 7,
                    data: visitorSeries,
                    lineStyle: {
                        width: 3
                    }
                },
                {
                    name: "페이지뷰",
                    type: "line",
                    smooth: true,
                    symbol: "circle",
                    symbolSize: 7,
                    data: viewSeries,
                    areaStyle: {
                        opacity: 0.15
                    },
                    lineStyle: {
                        width: 3
                    }
                }
            ]
        };

        trafficTrendChart.setOption(trafficTrendOption);

        window.addEventListener("resize", function () {
            trafficTrendChart.resize();
        });
    }
});