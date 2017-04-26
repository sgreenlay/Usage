var update;

// Modified from: http://stackoverflow.com/questions/15900485/correct-way-to-convert-size-in-bytes-to-kb-mb-gb-in-javascript
function formatBytes(bytes, decimals) {
   if(bytes == 0) return '0 Bytes';
   var k = 1000,
       dm = decimals || 2,
       sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
       i = Math.min(Math.floor(Math.log(bytes) / Math.log(k)), 8);
   return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
}

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
    cell.innerHTML = "Upload";
    header.appendChild(cell);

    cell = document.createElement("th");
    cell.width = "25%";
    cell.style = "text-align: center;"
    cell.innerHTML = "Download";
    header.appendChild(cell);

    cell = document.createElement("th");
    cell.width = "25%";
    cell.style = "text-align: center;"
    cell.innerHTML = "Total";
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

        var upload = parseInt(info[1]);
        cell = document.createElement("td");
        cell.innerHTML = formatBytes(upload);
        cell.style = "text-align: center;"
        row.appendChild(cell);

        var download = parseInt(info[2]);
        cell = document.createElement("td");
        cell.innerHTML = formatBytes(download);
        cell.style = "text-align: center;"
        row.appendChild(cell);

        var total = parseInt(info[1]) + parseInt(info[2]);
        cell = document.createElement("td");
        cell.innerHTML = formatBytes(total);
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
