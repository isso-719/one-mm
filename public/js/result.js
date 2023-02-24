window.onload = function() {
    // ブラボー数を 0.25 秒ごとに更新
    setInterval(function() {
        req = GetRequest("/api/fetch");
        var data = JSON.parse(req);
        var bravo = data.bravo;
        var not_bravo = data.not_bravo;
        var total = bravo + not_bravo;

        if (total === 0) {
            total = 1;
        }

        document.getElementById('bravo-count').innerHTML = bravo;
        document.getElementById('not-bravo-count').innerHTML = not_bravo;
        document.getElementById('bravo-percentage').innerHTML = Math.round(bravo / total * 100) + '%';
        document.getElementById('not-bravo-percentage').innerHTML = Math.round(not_bravo / total * 100) + '%';
    }, 250);
}

function Reset() {
    // Button Analytics を呼び出す
    ButtonAnalytics("bravo");

    // Click 時に発火するイベントを記述
    PostRequest("/api/reset");
}