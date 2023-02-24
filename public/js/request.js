function GetRequest(path) {
    var request = new XMLHttpRequest();
    request.open("GET", path, false);
    request.send(null);

    if (request.status !== 200) {
        alert("Error: " + request.status);
    }

    return request.responseText;
}

function PostRequest(path) {
    var request = new XMLHttpRequest();
    request.open("POST", path, false);
    request.send(null);

    if (request.status !== 200) {
        alert("Error: " + request.status);
    }

    return request.responseText;
}