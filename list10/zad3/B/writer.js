var http = require('http');
var bodyParser = require('body-parser');
var express = require('express');
var app = express();
app.use(bodyParser.urlencoded({ extended: false }));

var DB_URL = process.env.DB_URL

app.post('/write', (req, res) => {
    var note = req.body.note;
    console.log(note);
    
    res.send('done');
})

var server = http.createServer(app).listen(4000);
console.log( 'server started' );