<div align="center">

# Smart Home Authorization Server
A phoenix server that allows for IoT devices to check for user access

</div>

## Why?
For our [Smart Home Security System](https://github.com/dwyl/smart-home-security-system) 
we need to be able to indentify users and devices
and check their access rights. This is a key part of the system and is our 'single
source of truth.' It integrates with the Dwyl authentication system using `auth_plug`
and stores as little personal infomation as possible.

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
Follow the instructions [here](https://github.com/dwyl/auth_plug#2-get-your-auth_api_key-)
to get and set your API key.

### Run

To start the Phoenix server:

  * Install dependencies with `mix deps.get`
  * Edit database config in `config/dev.exs` 
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`


## Development

`insomnia.json` is an export of the [Insomnia](https://insomnia.rest)
workspace I'm currently using to develop the API.
It should have most routes and authentication configured.

I recommend using Insomnia for development.
