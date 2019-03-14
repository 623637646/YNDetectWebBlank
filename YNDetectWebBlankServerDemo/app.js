var express = require('express');
var app = express();
var ip = require('ip');
var port = 3000;

app.get('/', function (req, res) {
    res.send('Hello World!');
});

app.get('/normal', function (req, res) {
    res.send('This is a normal page!');
});

app.get('/blank', function (req, res) {
    res.send('');
});

app.get('/timeOut', function (req, res) {

});

app.listen(port, function () {
    console.log('Server started');
    console.log('Please input server ip to YNDetectWebBlankDemo: ' + ip.address());
});