window.onload = function() {
    const ctx = document.getElementById('resChart');
    let data = [50, 50];
    const opt = {
        type: 'pie',
        data: {
            datasets: [{
                data: data,
                borderWidth: 1,
                backgroundColor: ['#051970', '#F9C200'],
            }],
        },
    };
    let chart = new Chart(ctx, opt);

    let bravo_percentage = 50;
    let not_bravo_percentage = 50;

    // ブラボー数を 0.5 秒ごとに更新
    setInterval(function() {
        req = GetRequest("/api/fetch");
        let data = JSON.parse(req);
        let bravo = data.bravo;
        let not_bravo = data.not_bravo;
        let total = bravo + not_bravo;

        if (total === 0) {
            total = 1;
        }

        bravo_percentage = Math.round(bravo / total * 100);
        not_bravo_percentage = Math.round(not_bravo / total * 100);

        if (bravo === 0 && not_bravo === 0) {
            bravo_percentage = 50;
            not_bravo_percentage = 50;
        }

        // もし、データが変わっていたら、グラフを更新
        if (data[0] !== bravo_percentage || data[1] !== not_bravo_percentage) {
            data = [not_bravo_percentage, bravo_percentage];
            chart.data.datasets[0].data = data;
            chart.update();

            // ブラボー率を更新
            document.getElementById('bravo-percentage').innerHTML = bravo_percentage + '%';

            document.getElementById('not-bravo-percentage').innerHTML = not_bravo_percentage + '%';
        }
    }, 500);
}