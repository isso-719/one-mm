function GetRequest(path) {
    let request = new XMLHttpRequest();
    request.open("GET", path, false);
    request.send(null);

    if (request.status !== 200) {
        alert("Error: " + request.status);
    }

    return request.responseText;
}

function PostRequest(path, data) {
    let request = new XMLHttpRequest();
    if (data === null) {
        request.open("POST", path, false);
        request.send(null);
    } else {
        request.open("POST", path, false);
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        request.send(data);
    }

    if (request.status !== 200) {
        alert("Error: " + request.status);
    }

    return request.responseText;
}