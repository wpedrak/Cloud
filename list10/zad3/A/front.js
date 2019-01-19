var http = require('http');
var bodyParser = require('body-parser');
var express = require('express');
var request = require('request');
var app = express();
app.use(bodyParser.urlencoded({ extended: false }));


var WRITER_IP = process.env.WRITER_IP || '127.0.0.1'
var WRITER_PORT = 4000
var READER_IP = process.env.READER_IP || '127.0.0.1'
var READER_PORT = 5000


app.set('view engine', 'ejs');
app.set('views', './views');

app.get('/',(req,res) => {
    context = {
        'reader_ip': READER_IP,
        'reader_port': READER_PORT
    };

    request('http://' + READER_IP + ':' + READER_PORT + '/notes', function (error, response, body) {
        console.log('error:', error); // Print the error if one occurred
        console.log('statusCode:', response && response.statusCode); // Print the response status code if a response was received
        console.log('body:', body); // Print the HTML for the Google homepage.


        var notes;

        if (body) {
            notes = body.split(',');
        }
        
        
        context['notes'] = notes || [];
        res.render('index', context);
      });
});

app.post('/write', (req, res) => {
    var note = req.body.note;
    console.log(note);
    // console.log(req.body);

    request.post('http://' + WRITER_IP + ':' + WRITER_PORT + '/write').form({'note': note})

    res.redirect('/')
})

var server = http.createServer(app).listen(3000);
console.log( 'server started' );