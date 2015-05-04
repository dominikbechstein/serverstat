###
The MIT License (MIT)

Copyright (c) <2015> Dominik Winter <info at edge-project.org>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
###


express  = require "express"
fs       = require "fs"
ssh2     = require "ssh2"
https    = require "https"
socket   = require "socket.io"
config   = require "./config.coffee"

app = express()

app.use express.static __dirname + "/public"
app.use express.static __dirname + "/node_modules"

ssl_options =
    key:                fs.readFileSync config.key
    cert:               fs.readFileSync config.cert
    requestCert:        config.requestCert
    rejectUnauthorized: config.rejectUnauthorized

server = https.createServer ssl_options, app
io = socket.listen server

server.listen config.port

console.info "listening on", config.port

ServerStatus = (servers, io) ->
    slimServerSettings = []

    servers.forEach (server, id) ->
        slimServerSettings.push
            hostname:   server.hostname
            color:      server.color

        connection = new ssh2
        hostname   = server.hostname

        getLoad = () ->
            connection.exec "cat /proc/loadavg", (err, stream) ->
                throw err if err

                stream.on "data", (data) ->
                    console.info "#{hostname}", data.toString()

                    io.sockets.emit "update",
                        id:   id
                        load: data.toString().trim().split(" ")[0] * 1

                stream.on "exit", ->
                    setTimeout getLoad, 1000

        connection.on "ready", ->
            console.info "connection established on #{hostname}"
            getLoad()

        connection.on "error", (err) ->
            console.error "error occured on #{hostname}", err

        connection.on "end", ->
            console.info "connection ended on #{hostname}"

        connection.on "close", ->
            console.info "connection closed on #{hostname}"

        connection.connect
            host:       server.hostname
            port:       server.port
            username:   server.username
            password:   server.password
            privateKey: if server.privateKey then fs.readFileSync server.privateKey else null
            passphrase: server.passphrase

    io.sockets.on "connection", (socket) ->
        socket.emit "init", slimServerSettings

new ServerStatus config.servers, io
