# digging

[![Build Status](https://travis-ci.org/ninoseki/digging.svg?branch=master)](https://travis-ci.org/ninoseki/digging)
[![Maintainability](https://api.codeclimate.com/v1/badges/07802a0ac721ed06b6a9/maintainability)](https://codeclimate.com/github/ninoseki/digging/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/digging/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/digging?branch=master)

digging is a WEB API for DNS digging.

## How to use

In order to send a data you must perform an HTTP POST request to the following URL:

- `https://dns-digging.herokuapp.com/`

The API call expects the following parameter:

- `name`: the name of the resource record that is to be looked up.
- `type`: the type of query: A, AAAA, CNAME, NX, NS, SOA, TXT.
- `server`(optional): the name or IP address of the name server to query. If not specified `8.8.8.8` will be used.

**Example code**:

```sh
curl -X POST dns-digging.herokuapp.com -d "type=A&&name=google.com"
```

**Example response**:

```json
{
  "address": "172.217.26.14",
  "ttl": "178"
}
```
