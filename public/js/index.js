function PostRequest(path) {
    var request = new XMLHttpRequest();
    request.open("POST", path, false);
    request.send(null);

    if (request.status !== 200) {
        alert("Error: " + request.status);
    }
}

function Bravo() {
    PostRequest("/api/bravo");
}
function NotBravo() {
    PostRequest("/api/not-bravo");
}