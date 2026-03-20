/* kakaoShare.js */

window.addEventListener('load', function () {
    const shareBtn = document.getElementById('kakaoShareBtn');
    if (!shareBtn) return;

    if (typeof Kakao === 'undefined') {
        console.error('Kakao SDK가 로드되지 않았습니다.');
        return;
    }

    if (!Kakao.isInitialized()) {
        Kakao.init('cf80e14ee6369fffa6d4124ab3dd803d');
    }

    shareBtn.addEventListener('click', function (event) {
        event.stopPropagation();

        const data = window.kakaoShareData || {};

        const title = data.title || '맛침내 커뮤니티';
        const description = data.description || '맛침내 커뮤니티 게시글입니다.';
        const imageUrl = data.imageUrl || 'https://developers.kakao.com/assets/img/about/logos/kakaolink/kakaolink_btn_small.png';
        const webUrl = data.webUrl || window.location.href;
        const mobileWebUrl = data.mobileWebUrl || window.location.href;

        Kakao.Share.sendDefault({
            objectType: 'feed',
            content: {
                title: title,
                description: description,
                imageUrl: imageUrl,
                link: {
                    mobileWebUrl: mobileWebUrl,
                    webUrl: webUrl
                }
            },
            buttons: [
                {
                    title: '게시글 보러가기',
                    link: {
                        mobileWebUrl: mobileWebUrl,
                        webUrl: webUrl
                    }
                }
            ]
        });
    });
});