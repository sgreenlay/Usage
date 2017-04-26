var update;

function update_UsageTable(usage) {
    var value = document.getElementById('usages');
    value.innerHTML = '';

    var table = document.createElement("table");
    table.classList.add("table");
    table.classList.add("center");
    table.cellSpacing = 5;

    var header = table.insertRow(0);

    var cell = document.createElement("th");
    cell.width = "25%";
    cell.style = "text-align: center;"
    cell.innerHTML = "IP Address";
    header.appendChild(cell);

    cell = document.createElement("th");
    cell.width = "25%";
    cell.style = "text-align: center;"
    cell.innerHTML = "Upload (Mb)";
    header.appendChild(cell);

    cell = document.createElement("th");
    cell.width = "25%";
    cell.style = "text-align: center;"
    cell.innerHTML = "Download (Mb)";
    header.appendChild(cell);

    cell = document.createElement("th");
    cell.width = "25%";
    cell.style = "text-align: center;"
    cell.innerHTML = "Total (Mb)";
    header.appendChild(cell);

    var clients = usage.split(';');
    clients.splice(-1,1);

    clients.forEach(function(client) {
        var row = table.insertRow();

        var info = client.split(':');

        var ip = info[0];
        var cell = document.createElement("td");
        cell.innerHTML = ip;
        cell.style = "text-align: center;"
        row.appendChild(cell);

        var upload = info[1];
        cell = document.createElement("td");
        cell.innerHTML = upload;
        cell.style = "text-align: center;"
        row.appendChild(cell);

        var download = info[2];
        cell = document.createElement("td");
        cell.innerHTML = download;
        cell.style = "text-align: center;"
        row.appendChild(cell);

        var total = parseFloat(info[1]) + parseFloat(info[2]);
        total = total.toFixed(2);
        cell = document.createElement("td");
        cell.innerHTML = total;
        cell.style = "text-align: center;"
        row.appendChild(cell);
    }, this);

    value.appendChild(table);
}

addEvent(window, 'load', function () {
    update = new StatusUpdate('user/traffic.asp', 1);
    update.onUpdate('usage', function (evt) {
        update_UsageTable(evt.usage);
    });
    update.start();
});

addEvent(window, 'unload', function () {
    update.stop();
});
