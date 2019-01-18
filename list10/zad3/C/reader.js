var http = require('http');
var express = require('express');
var app = express();
var pgp = require('pg-promise')(/*options*/)
var DB_PASSWORD = process.env.DB_PASSWORD || ''
var DB_IP = process.env.DB_IP || '35.204.186.169'
var db = pgp(process.env.DB_URL || 'postgres://wpedrak:' + DB_PASSWORD + '@' + DB_IP + ':5432/notes')

app.get('/notes',(req,res) => {
    db.any('SELECT * FROM notes')
    .then(function (data) {
        // console.log('DATA:', data)
        var arrayed = data.map( elem => {
            return elem.note
        });
        console.log('DATA:', arrayed)
        return res.send('' + arrayed)
    })
    .catch(function (error) {
        console.log('ERROR:', error)
        res.send("[error]: " + error)
    })
});

var server = http.createServer(app).listen(5000);
console.log( 'server started' );