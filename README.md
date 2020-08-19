<div align="center">

# Smart Home Authorization Server

A Phoenix server that allows for IoT devices to check for user access.

[![Build Status](https://img.shields.io/travis/com/dwyl/smart-home-auth-server/master.svg?style=flat-square)](https://travis-ci.com/github/dwyl/smart-home-auth-server)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/smart-home-auth-server/master.svg?style=flat-square)](http://codecov.io/github/dwyl/smart-home-auth-server?branch=master)



</div>

## Why?

For our [Smart Home Security System](https://github.com/dwyl/smart-home-security-system)
we need to be able to identify people and devices
and check their access rights.
This is a key part of the system
and is our 'single source of truth.'
It integrates with the Dwyl authentication system using
[`auth_plug`](https://github.com/dwyl/auth_plug)
and stores as little personal information as possible.

## What?

This is a simple Phoenix-Based REST service made of three key parts:

+ **Devices**

  Devices can be added and removed from the system. They can be NFC tags or more
  complicated devices like phones. These devices are automatically associated with
  the logged in user.

+ **Locks**

  (Called *doors* internally - we should refractor this at some point).

  Add locks to the system and add or remove users access to them. Locks are
  uniquely identified and associated with users through the `keyholders` table.

+ **Access**

  Looks up a user and lock and determines whether to grant access or not.


## How?

### Clone the project
```
git clone https://github.com/dwyl/smart-home-auth
```

### Set `AUTH_API_KEY`

Follow the
[instructions to get your API Key](https://github.com/dwyl/auth_plug#2-get-your-auth_api_key-)

### Run

To start the Phoenix server:

  * Install dependencies with `mix deps.get`
  * Edit database config in `config/dev.exs`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`


## API Development

[`insomnia.json`](https://github.com/dwyl/smart-home-auth-server/blob/master/insomnia.json)
is an export of the [Insomnia](https://insomnia.rest)
workspace used to develop the API.
It should have most routes and authentication configured.

We recommend using Insomnia for development,
see: https://github.com/dwyl/learn-insomnia
