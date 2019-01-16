var http = require('http');
var bodyParser = require('body-parser');
var express = require('express');
var request = require('request');
var app = express();
app.use(bodyParser.urlencoded({ extended: false }));


var WRITER_IP = process.env.WRITER_IP || '127.0.0.1'
var READER_IP = process.env.READER_IP || '127.0.0.1'

app.set('view engine', 'ejs');
app.set('views', './views');

app.get('/',(req,res) => {
    context = {};
    res.render('index', context);
});

app.post('/write', (req, res) => {
    var note = req.body.note;
    console.log(note);
    // console.log(req.body);

    request.post('http://' + WRITER_IP + ':4000/write').form({'note': note})

    res.redirect('/')
})

var server = http.createServer(app).listen(3000);
console.log( 'server started' );