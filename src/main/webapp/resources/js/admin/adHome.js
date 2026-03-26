/* adHome.js */

console.log("adHome.js loaded");

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

    function getStartDateByRange(days) {
        const today = new Date();
        const start = new Date(today);
        start.setDate(today.getDate() - (days - 1));
        return formatDate(start);
    }

    function safeArray(value) {
        return Array.isArray(value) ? value : [];
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
    // 서버 데이터
    // -------------------------------------------------
    const adminHomeData = window.adminHomeData || {};
    const trendList = safeArray(adminHomeData.trendList);
    const npsDistribution = safeArray(adminHomeData.npsDistribution);
    const trafficTrendList = safeArray(adminHomeData.trafficTrendList);
    const today = adminHomeData.today || "";

    console.log("adminHomeData =>", adminHomeData);

    // -------------------------------------------------
    // 최근 만족도 차트
    // -------------------------------------------------
    try {
        const trendDates = trendList.map(item => item.statDate);
        const satisfactionData = trendList.map(item => item.satisfactionAvg);
        const infoReliabilityData = trendList.map(item => item.infoReliabilityAvg);
        const npsTrendData = trendList.map(item => item.npsAvg);

        const todayIndex = trendDates.indexOf(today);

        const trendChartEl = document.getElementById("trendChart");
        if (trendChartEl && typeof echarts !== "undefined") {
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
                        lineStyle: { color: "#cfd8e3" }
                    },
                    axisLabel: { color: "#6b7785" }
                },
                yAxis: {
                    type: "value",
                    axisLine: { show: false },
                    splitLine: {
                        lineStyle: { color: "#eef2f7" }
                    },
                    axisLabel: { color: "#6b7785" }
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
    } catch (error) {
        console.error("최근 만족도 차트 렌더 오류:", error);
    }

    // -------------------------------------------------
    // NPS 분포 차트
    // -------------------------------------------------
    try {
        const npsChartEl = document.getElementById("npsChart");
        if (npsChartEl && typeof echarts !== "undefined") {
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
                        return `${params.name}<br/>${params.value}건`;
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
    } catch (error) {
        console.error("NPS 분포 차트 렌더 오류:", error);
    }

    // -------------------------------------------------
    // GA 기간별 트래픽 추이
    // -------------------------------------------------
    try {
        const trafficDates = trafficTrendList.map(item => item.date);
        const visitorSeries = trafficTrendList.map(item => item.visitorCount);
        const viewSeries = trafficTrendList.map(item => item.viewCount);

        const trafficTrendChartEl = document.getElementById("trafficTrendChart");
        if (trafficTrendChartEl && typeof echarts !== "undefined") {
            const trafficTrendChart = echarts.init(trafficTrendChartEl);

            trafficTrendChart.setOption({
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
                        lineStyle: { color: "#cfd8e3" }
                    },
                    axisLabel: { color: "#6b7785" }
                },
                yAxis: {
                    type: "value",
                    axisLine: { show: false },
                    splitLine: {
                        lineStyle: { color: "#eef2f7" }
                    },
                    axisLabel: { color: "#6b7785" }
                },
                series: [
                    {
                        name: "방문자 수",
                        type: "line",
                        smooth: true,
                        symbol: "circle",
                        symbolSize: 7,
                        data: visitorSeries,
                        lineStyle: { width: 3 }
                    },
                    {
                        name: "페이지뷰",
                        type: "line",
                        smooth: true,
                        symbol: "circle",
                        symbolSize: 7,
                        data: viewSeries,
                        areaStyle: { opacity: 0.15 },
                        lineStyle: { width: 3 }
                    }
                ]
            });

            window.addEventListener("resize", function () {
                trafficTrendChart.resize();
            });
        }
    } catch (error) {
        console.error("트래픽 차트 렌더 오류:", error);
    }

    // -------------------------------------------------
    // 워드클라우드
    // - hidden input.subjective-word-source 값 사용
    // - 내부 API(/admin/wordcloud.ad) 호출 후 이미지 렌더링
    // -------------------------------------------------
    try {
        renderWordCloud();
    } catch (error) {
        console.error("워드클라우드 렌더 초기화 오류:", error);
    }

    function renderWordCloud() {
    const wordcloudBox = document.getElementById("wordcloudBox");
    const sourceInputs = document.querySelectorAll(".subjective-word-source");

    if (!wordcloudBox) return;

    const rawTexts = Array.from(sourceInputs)
        .map(input => input.value ? input.value.trim() : "")
        .filter(Boolean);

    if (rawTexts.length === 0) {
        wordcloudBox.innerHTML = '<p class="text-muted mb-0">기간 내 서술형 응답 데이터가 없습니다.</p>';
        return;
    }

    const mergedText = rawTexts.join(" ").replace(/\s+/g, " ").trim();

    if (!mergedText) {
        wordcloudBox.innerHTML = '<p class="text-muted mb-0">워드클라우드로 생성할 텍스트가 없습니다.</p>';
        return;
    }

    wordcloudBox.innerHTML = '<p class="text-muted mb-0">워드클라우드를 생성 중입니다...</p>';

    fetch(path + "/admin/wordcloud.ad", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
        },
        body: "text=" + encodeURIComponent(mergedText)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error("HTTP status " + response.status);
        }
        return response.text();
    })
    .then(dataUri => {
        if (!dataUri || !dataUri.startsWith("data:image")) {
            wordcloudBox.innerHTML = '<p class="text-muted mb-0">워드클라우드 생성에 실패했습니다.</p>';
            return;
        }

        wordcloudBox.innerHTML = `
            <img src="${dataUri}"
                 alt="사용자 만족도 워드클라우드"
                 class="img-fluid wordcloud-image">
        `;
    })
    .catch(error => {
        console.error("워드클라우드 API 오류:", error);
        wordcloudBox.innerHTML = '<p class="text-muted mb-0">워드클라우드 로딩 중 오류가 발생했습니다.</p>';
    });
}
    
    
});