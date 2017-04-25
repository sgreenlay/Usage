var update;

addEvent(window, 'load', function () {
    update = new StatusUpdate('user/traffic.asp', 1);
    update.onUpdate('test', function (evt) {
        var value = document.getElementById('value');
        value.innerHTML = evt.test;
    });
    update.start();
});

addEvent(window, 'unload', function () {
    update.stop();
});
