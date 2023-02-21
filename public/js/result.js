// WebSocketのインスタンスを作成
if (location.protocol === 'https:') {
    var ws = new WebSocket('wss://' + location.host + '/websocket/counts');
} else {
    var ws = new WebSocket('ws://' + location.host + '/websocket/counts');
}

// 接続が確立した時の処理
ws.onopen = function () {
    console.log('接続が確立しました');
};

// メッセージを受信した時の処理
ws.onmessage = function (event) {
    var data = JSON.parse(event.data);
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
};

// 接続が切れた時の処理
ws.onclose = function () {
    console.log('接続が切れました');
};

// エラーが発生した時の処理
ws.onerror = function (error) {
    console.log('エラーが発生しました: ' + error);
};

function Reset() {
    // Button Analytics を呼び出す
    ButtonAnalytics("bravo");

    // Click 時に発火するイベントを記述
    PostRequest("/api/reset");
}