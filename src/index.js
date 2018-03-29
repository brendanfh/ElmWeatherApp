'use strict';

require("./index.html");

var Elm = require('./elm/Main.elm');
var targetNode = document.getElementById("main");

var app = Elm.Main.embed(targetNode);