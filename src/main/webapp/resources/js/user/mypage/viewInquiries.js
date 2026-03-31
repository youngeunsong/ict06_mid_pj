function movePage(page) {
    location.href = contextPath + '/viewInquiries.do?pageNum=' + page + '&status=' + inquiryStatus;
}

function filterInquiry(type) {
    location.href = contextPath + '/viewInquiries.do?status=' + type + '&pageNum=1';
}