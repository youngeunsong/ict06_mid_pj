/* adHome.js */

console.log("adHome.js loaded");

document.addEventListener("DOMContentLoaded", function () {

	// 변수 선언
    const startInput = document.getElementById("startDate"); // 시작일
    const endInput = document.getElementById("endDate"); // 종류일
    const rangeButtons = document.querySelectorAll(".range-btn"); //날짝 버튼 클래스(7일/ 30일/ 90일/ 6개월/ 1년)

    // 공통 유틸
	// 1) 기간 설정 버튼 클래스에서 active 삭제
    function clearActiveButtons() {
        rangeButtons.forEach(btn => btn.classList.remove("active"));
    }

	// 2-1) Date 객체를 yyyy-MM-dd 문자열로 변환
    function getStartDateByRange(days) {
        const today = new Date();
        const start = new Date(today);
        start.setDate(today.getDate() - (days - 1));
        return formatDate(start);
    }
    
    // 2-2) 값을 기준으로 N일 전 시작일을 계산해서 yyyy-MM-dd로 반환
    function formatDate(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, "0");
        const day = String(date.getDate()).padStart(2, "0");
        return `${year}-${month}-${day}`;
    }

	// 3) value가 배열이면 그대로 쓰고, 배열이 아니면 []를 반환
    function safeArray(value) {
        return Array.isArray(value) ? value : [];
    }
    
    // 기간 버튼 active 처리
    function syncActiveButton() {
    	// 값이 없으면 돌아가라
        if (!startInput || !endInput || rangeButtons.length === 0) {
            return;
        }

		//시작일, 종류일 값 가져오기
        const currentStart = startInput.value;
        const currentEnd = endInput.value;

		// 1 실행) 기간 설정 버튼 클래스에서 active 삭제
        clearActiveButtons();

		// 값이 없으면 돌아가라
        if (!currentStart || !currentEnd) {
            return;
        }

		// 2-2 실행) 값(오늘날짜)을 기준으로 N일 전 시작일을 계산해서 yyyy-MM-dd로 반환
        const todayStr = formatDate(new Date());

		// 값이 없으면 돌아가라
        if (currentEnd !== todayStr) {
            return;
        }

		//2-1 실행) Date 객체를 yyyy-MM-dd 문자열로 변환
        rangeButtons.forEach(btn => {
            const days = Number(btn.dataset.range);
            const expectedStart = getStartDateByRange(days);

            if (currentStart === expectedStart) {
                btn.classList.add("active");
            }
        });
    }

	// 클릭한 버튼 클래스에 active 추가
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

	// echart를 이용한 차트 그리기 시작
    // JSP에서 window 전역 객체로 넘겨준 데이터(adminHomeData)
    const adminHomeData = window.adminHomeData || {}; // 값이 없을 시 {} 처리
    const trafficTrendList = safeArray(adminHomeData.trafficTrendList); // // GA 기간별 트래픽 추이용 데이터
    const trendList = safeArray(adminHomeData.trendList); // 최근 만족도 차트용 데이터
    const npsDistribution = safeArray(adminHomeData.npsDistribution); // NPS 분포 차트용 데이터
    const today = adminHomeData.today || ""; // 오늘 날짜

    console.log("adminHomeData =>", adminHomeData);
    
    // GA4 : 기간별 트래픽 추이
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

    // 최근 만족도
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

    // NPS 평점 분포 차트
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
    // 워드클라우드
    // - hidden input.subjective-word-source 값 사용
    // - 내부 API(/admin/wordcloud.ad) 호출 후 이미지 렌더링
    // -------------------------------------------------
    // 워드클라우드 렌더링
    try {
        renderWordCloud();
    } catch (error) {
        console.error("워드클라우드 렌더 초기화 오류:", error);
    }

	// 워드클라우드 렌더를 위한 데이터 필터 및 서버 호출
    function renderWordCloud() {
    const wordcloudBox = document.getElementById("wordcloudBox"); // 워드클라우드 출력 영역
    const sourceInputs = document.querySelectorAll(".subjective-word-source"); // 워드클라우드 데이터

	// 값이 없으면 돌아가라
    if (!wordcloudBox) return;

	// 배열로 변환
    const rawTexts = Array.from(sourceInputs)
        .map(input => input.value ? input.value.trim() : "") // 공백 제거
        .filter(Boolean); // 빈 문자열 제거

	// 데이터가 없을 시 메시지
    if (rawTexts.length === 0) {
        wordcloudBox.innerHTML = '<p class="text-muted mb-0">기간 내 서술형 응답 데이터가 없습니다.</p>';
        return;
    }

	// 배열로 변환 된 데이터를 통 문자열로 합치기
	// 공백 최적화 및 양 끝 공백 제거 후 합치기
    const mergedText = rawTexts.join(" ").replace(/\s+/g, " ").trim();

	// 데이터가 없을 시 메시지
    if (!mergedText) {
        wordcloudBox.innerHTML = '<p class="text-muted mb-0">워드클라우드로 생성할 텍스트가 없습니다.</p>';
        return;
    }

	// 로딩 시 진행중이라는 것을 알리는 멘트 출력
    wordcloudBox.innerHTML = '<p class="text-muted mb-0">워드클라우드를 생성 중입니다...</p>';

	// 워드클라우드 API 호출 => 생성 요청(controller에게 응답을 보내서 service 타기)
    fetch(path + "/admin/wordcloud.ad", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
        },
        body: "text=" + encodeURIComponent(mergedText) // 한글과 공백이 깨지지 않도록
    })
    // 성공 시 문자열 반환
    .then(response => { // response는 Service에서 결과 생성하여 돌려준 값
        if (!response.ok) {
            throw new Error("HTTP status " + response.status);
        }
        return response.text(); // body를 문자열로 읽음
    })
    // 성공 시 이미지 렌더링
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
    // 실패 시
    .catch(error => {
        console.error("워드클라우드 API 오류:", error);
        wordcloudBox.innerHTML = '<p class="text-muted mb-0">워드클라우드 로딩 중 오류가 발생했습니다.</p>';
    });
}
    
    
});