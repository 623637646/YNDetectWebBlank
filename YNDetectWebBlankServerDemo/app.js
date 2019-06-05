var express = require('express');
var app = express();
var ip = require('ip');
var port = 3000;
var delay = 500;

app.get('/', function (req, res) {
    res.send('Hello World!');
});

app.get('/normal', function (req, res) {
    setTimeout(function () {
        res.send('<h1>This is a normal page.</h1>');
    }, delay);
});

app.get('/blank', function (req, res) {
    setTimeout(function () {
        res.send('');
    }, delay);
});

app.get('/timeOut', function (req, res) {

});


app.listen(port, function () {
    console.log('Server started');
    console.log('Please input server ip to YNDetectWebBlankDemo: ' + ip.address());
});