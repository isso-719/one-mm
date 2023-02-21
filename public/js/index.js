function Bravo() {
    // Button Analytics を呼び出す
    ButtonAnalytics("bravo");

    // Click 時に発火するイベントを記述
    PostRequest("/api/bravo");
}
function NotBravo() {
    // Button Analytics を呼び出す
    ButtonAnalytics("not_bravo");
    // Click 時に発火するイベントを記述
    PostRequest("/api/not-bravo");
}