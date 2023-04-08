function Reset() {
    // Button Analytics を呼び出す
    ButtonAnalytics("reset");

    PostRequest("/api/reset", null);
}

function Enable() {
    // Button Analytics を呼び出す
    ButtonAnalytics("enable");
    PostRequest("/api/count-enable", null);
    CheckCountAvailability();
}

function Disable() {
    // Button Analytics を呼び出す
    ButtonAnalytics("disable");
    PostRequest("/api/count-disable", null);
    CheckCountAvailability();
}

function SaveSpreadSheet() {
    // Button Analytics を呼び出す
    ButtonAnalytics("save_spreadsheet");

    let mentor_name = document.getElementById('mentor-name').value;
    PostRequest("/api/save", "mentor_name=" + mentor_name);

    document.getElementById('mentor-name').value = "";

    // 3 秒だけ save-success し、フェードアウトする
    document.getElementById('save-success').style.display = "block";
    setTimeout(function() {
        document.getElementById('save-success').style.display = "none";
    }, 3000);
}

function CheckCountAvailability() {
    let res = GetRequest("/api/count-available");
    let mes;
    res = JSON.parse(res);
    if (res.availability === true) {
        mes = "カウントが有効です。";
    } else {
        mes = "カウントが無効です。";
    }
    document.getElementById('count-availability').innerHTML = mes;
}

function CheckAllCounts() {
    // /api/fetch で全てのカウントを取得
    let res = GetRequest("/api/fetch");
    res = JSON.parse(res);

    // ブラボー数を取得
    let bravo_count = res.bravo;
    let not_bravo_count = res.not_bravo;

    // 表示
    document.getElementById('bravo-count').innerHTML = bravo_count;
    document.getElementById('not-bravo-count').innerHTML = not_bravo_count;
}

// window が表示されたら、カウントの有効性をチェックする
window.onload = function() {
    CheckCountAvailability();

    // 1.5 秒ごとにカウントの有効性をチェックする
    setInterval(function() {
        CheckCountAvailability();
        CheckAllCounts();
    }, 1500);
}