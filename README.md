# Spotify playlist

Remove the songs added to the playlist "Remove from spotify" from every playlists.

More information here [https://community.spotify.com/t5/Live-Ideas/Delete-song-from-playlist-in-Now-playing-menu-Mobile/idc-p/1711248](https://community.spotify.com/t5/Live-Ideas/Delete-song-from-playlist-in-Now-playing-menu-Mobile/idc-p/1711248).

The live version is available here: [https://spotify-playlist.eivo.fr](https://spotify-playlist.eivo.fr)

## Installation

### Requirements

- PostgreSQL / MySQL
- recommended [rvm](https://rvm.io/) to manage multiple ruby version

### Prcocess

If you have rvm installed, when you enter in the folder you may have a text saying:
```
ruby-2.X.X is not installed.
To install do: 'rvm install ruby-2.X.X'
```
When done, leave and re-enter in the folder, you can check everything is good with `rvm info`.

- `bundle install` install all gems and needs to be done each time `Gemfile` changed
- Confgiure `config/database.yml` check `config/database.yml.example`
- `rails db:create` for create a database, just need to be done the first time
- `rails db:migrate` create all tables with all columns

This project is configured to run in development on `http://vm.local:3000`.
On your desktop (not in the virtual machine if you have one), edit `/etc/hosts` and add this line:
```
192.168.134.128 vm.local
```
`192.168.134.128` is the ip of your virtual machine, if you don't have one, use `127.0.0.1`.

You also need to set some variables either in `config/secrets.yml.enc` or in `config/secrets.yml`.

## Running

### Development

Start a server listenning on port 3000:
`rails s -b 0.0.0.0`

You can access to the project at http://vm.local:3000

### Production

You need to generate a secret key base with `rails secret` and put it in `config/secrets.yml.enc` or `config/secrets.yml`.

Compile all assets and start a server listening `tmp/sockets/puma.sock`:
`./restart_production.sh`


## Author

- [Jonathan Tribouharet](https://github.com/jonathantribouharet) ([@johntribouharet](https://twitter.com/johntribouharet))

## License

This code is released under the MIT license. See the LICENSE file for more info.