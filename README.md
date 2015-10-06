# Server Stat

## Description

Watch your server's cpu load in a realtime graph.

## Installation

Type in your console:

```bash
git clone https://github.com/dominikwinter/serverstat.git
git serverstat
npm install
```

## Usage

1. Generate a self signed ssl certificat

        openssl genrsa -des3 -passout pass:x -out serverstat.pass.key 2048
        openssl rsa -passin pass:x -in serverstat.pass.key -out serverstat.key
        openssl req -new -key serverstat.key -out serverstat.csr
        openssl x509 -req -days 365 -in serverstat.csr -signkey serverstat.key -out serverstat.crt
2. Edit config.coffee file as desired
3. Type in your console:

        npm start
4. Then type in your browser <https://localhost:60000/>


Please write bug reports and feature requests or do pull requests.

Thanks ☺
