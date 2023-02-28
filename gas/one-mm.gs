// デプロイ時のパラメータ
// 1. デプロイタイプは「ウェブアプリ」を選択
// 2. 次のユーザーとしてアプリを実行: 自分
// 3. アプリケーションにアクセスできるユーザー: 全員

// doPost : POST Request を受け取る
function doPost(e) {
  var service = e.parameter.service;

  if (service === "one-mm-save") {
    var mentor_name = e.parameter.mentor_name;
    var bravo_rate = e.parameter.bravo_rate;
    var not_bravo_rate = e.parameter.not_bravo_rate;
    var bravo_counts = e.parameter.bravo_counts;
    var not_bravo_counts = e.parameter.not_bravo_counts;

    oneMmSave(mentor_name, bravo_rate, not_bravo_rate, bravo_counts, not_bravo_counts)

  }

  // 400 Bad Request
  return ContentService.createJsonOutput({
    "result": "error",
    "error": "service not found"
  }).setStatusCode(400);
}

// oneMmSave : 1mm結果 というシートの最終行にデータを追加する
function oneMmSave(mentor_name, bravo_rate, not_bravo_rate, bravo_counts, not_bravo_counts) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("1mm結果");
  var lastRow = sheet.getLastRow();

  var values = [
    [mentor_name, bravo_rate, not_bravo_rate, bravo_counts, not_bravo_counts]
  ];

  sheet.getRange(lastRow + 1, 1, values.length, values[0].length).setValues(values);

  // 200 Success
  return ContentService.createJsonOutput({
    "result": "success"
  }).setStatusCode(200);
}
