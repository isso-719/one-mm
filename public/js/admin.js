function Reset() {
    // Button Analytics を呼び出す
    ButtonAnalytics("bravo");

    // Click 時に発火するイベントを記述
    PostRequest("/api/reset");
}

function Enable() {
    PostRequest("/api/count-enable");
}

function Disable() {
    PostRequest("/api/count-disable");
}