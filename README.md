# Server Stat

## Description

Watch your server's cpu load in a realtime graph.

## Installation

Type in your console:

```bash
git clone git@github.com:dominikwinter/serverstat.git
cd serverstat
npm install
```

## Usage

1. Generate a self signed ssl certificat

        openssl genrsa -des3 -passout pass:x -out serverstat.pass.key 2048
        openssl rsa -passin pass:x -in serverstat.pass.key -out serverstat.key
        openssl req -new -key serverstat.key -out serverstat.csr
        openssl x509 -req -days 365 -in serverstat.csr -signkey serverstat.key -out serverstat.crt
2. Copy config.coffee.dist to config.coffee and edit as desired, e.g.

        # with ssh password
        {
            hostname: "myserver1.org"
            username: "dominik"
            password: "my_secret_password"
            port: 22
            color: color.red
        }

        # or with ssh key file
        {
            hostname: "myserver2.de"
            username: "dominik"
            privateKey: "/Users/dominik/.ssh/id_rsa"
            passphrase: "my_secret_passphrase"
            port: 54321
            color: color.blue
        }
3. Type in your console:

        npm start
4. Open your browser with <https://localhost:60000/>


Please write bug reports and feature requests or do pull requests.

Thanks ☺
