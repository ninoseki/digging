# digging

[![Ruby CI](https://github.com/ninoseki/digging/actions/workflows/test.yaml/badge.svg)](https://github.com/ninoseki/digging/actions/workflows/test.yaml)
[![Maintainability](https://api.codeclimate.com/v1/badges/07802a0ac721ed06b6a9/maintainability)](https://codeclimate.com/github/ninoseki/digging/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/digging/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/digging?branch=master)

digging is a Web API for DNS digging.

## Requirements

- Ruby 3.x

## Installation

```bash
git clone https://github.com/ninoseki/digging.git
cd digging

bundle install

bundle exec puma -C config/puma.rb
```

## How to use

In order to send data, you must perform an HTTP POST request to the root path of the web app. (e.g. `http://localhost:3000/`)

The API call expects the following parameter:

- `name`: the name of the resource record that is to be looked up.
- `type`: the type of query: A, AAAA, CNAME, NX, NS, SOA, TXT.
- `server`(optional): the name or IP address of the name server to query. If not specified `8.8.8.8` will be used.

**Example**:

```bash
$ curl -s -X POST localhost:3000 -d "type=A&&name=google.com" | jq .
[
  {
    "address": "172.217.175.78",
    "ttl": "300"
  }
]
```
