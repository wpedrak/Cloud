var http = require('http');
var bodyParser = require('body-parser');
var express = require('express');
var app = express();
var pgp = require('pg-promise')(/*options*/)
app.use(bodyParser.urlencoded({ extended: false }));
var DB_PASSWORD = process.env.DB_PASSWORD || ''
var DB_IP = process.env.DB_IP || '35.204.186.169'
var db = pgp(process.env.DB_URL || 'postgres://wpedrak:' + DB_PASSWORD + '@' + DB_IP + ':5432/notes')


app.post('/write', (req, res) => {
    var note = req.body.note;
    console.log(note);
    
    res.send('done');
    // db.any('INSERT INTO notes VALUES ($1)', note)
    // .then(function (data) {
    //     console.log('added')
    //     res.send('done');
    // })
    // .catch(function (error) {
    //     console.log('ERROR:', error)
    //     res.send("[error]: " + error)
    // })
})

var server = http.createServer(app).listen(4000);
console.log( 'server started' );