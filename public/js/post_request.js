function PostRequest(path) {
    var request = new XMLHttpRequest();
    request.open("POST", path, false);
    request.send(null);

    if (request.status !== 200) {
        alert("Error: " + request.status);
    }
}