var http = require('http');
var express = require('express');
var app = express();

app.get('/',(req,res) => {
    res.send('works');
});

app.get('/secret',(req,res) => {
    res.send(process.env.SECRET);
});

var server = http.createServer(app).listen(3000);
console.log( 'server started' );