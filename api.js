//Simple Http proxy server used to access the Dark Sky API
//while hiding the Dark Sky API Key

var express = require('express'); 
require("isomorphic-fetch");

var port = 8081;

var app = express();
var server = require('http').createServer(app);

app.get('/api/', (req, res) => {
    res.json({ message: "Welcome to the backend api for this weather application" });
});

let DARK_SKY_KEY = "3f94667200243b55a460c1541a133267";
let GOOGLE_MAPS_KEY = "AIzaSyAQKazSXoZht-_oDWD8Ha3CXoA4zOHWYao";

let darkSkyApi = "https://api.darksky.net/forecast/" + DARK_SKY_KEY + "/";

app.get('/api/darksky', (req, res) => {
    try {
        let coords = req.query.lat+","+req.query.lon;
        let url = darkSkyApi + coords;
        console.log("Loading " + url);

        fetch(url)
            .then((res) => {
                if (res.status != 200) {
                    res.status(res.status).json({ message: "Got bad data from Dark Sky" });
                }

                return res.json();
            }).then((data) => {
                res.status(200).json(data);
            });
    }
    catch (error) {
        console.error("Errors happened trying to load things ", error);
        res.status(500).json({ message: "Errors occuried requesting data from Dark Sky", err: error });
    }
});

app.get('/api/maps', (req, res) => {

});

console.log("Listening on port " + port);
server.listen(port);