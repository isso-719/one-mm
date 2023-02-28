function Reset() {
    // Button Analytics を呼び出す
    ButtonAnalytics("reset");

    PostRequest("/api/reset", null);
}

function Enable() {
    // Button Analytics を呼び出す
    ButtonAnalytics("enable");

    PostRequest("/api/count-enable", null);
}

function Disable() {
    // Button Analytics を呼び出す
    ButtonAnalytics("disable");

    PostRequest("/api/count-disable", null);
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