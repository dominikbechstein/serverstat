###

before you can begin, generate a self signed ssl certificat:


openssl genrsa -des3 -passout pass:x -out serverstat.pass.key 2048
openssl rsa -passin pass:x -in serverstat.pass.key -out serverstat.key
openssl req -new -key serverstat.key -out serverstat.csr
openssl x509 -req -days 365 -in serverstat.csr -signkey serverstat.key -out serverstat.crt


add some servers in the servers section, e.g.:

        {
            hostname: "myserver1.org"
            username: "dominik"
            password: "my_secret_password"
            port: 22
            color: color.red
        },
        {
            hostname: "myserver2.de"
            username: "dominik"
            privateKey: "/Users/dominik/.ssh/id_rsa"
            passphrase: "my_secret_passphrase"
            port: 54321
            color: color.blue
        }

###

color =
    blue:       "rgba(  0,   0, 255, .8)"
    green:      "rgba(  0, 255,   0, .8)"
    aqua:       "rgba(  0, 255, 255, .8)"
    red:        "rgba(255,   0,   0, .8)"
    violet:     "rgba(200,   0, 255, .8)"
    ochre:      "rgba(100, 100,   0, .8)"
    black:      "rgba(  0,   0,   0, .8)"
    lightblue:  "rgba(150, 150, 255, .8)"
    orange:     "rgba(200, 100,   0, .8)"

module.exports =
    port:               60000
    key:                "serverstat.key"
    cert:               "serverstat.crt"
    requestCert:        true
    rejectUnauthorized: false

    servers: [
        {
            hostname: "myserver1.org"
            username: "dominik"
            password: "my_secret_password"
            port: 22
            color: color.red
        }
    ]
