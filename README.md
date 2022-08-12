![Mindustry logo](https://raw.githubusercontent.com/mercxry/docker-mindustry/main/assets/mindustry-logo.png)

Mindustry is a hybrid tower-defense sandbox factory game. Create elaborate supply chains of conveyor belts to feed ammo into your turrets, produce materials to use for building, and defend your structures from waves of enemies.

## Usage

### Docker cli

```sh
docker run -d \
  --name mindustry \
  -p 6567:6567/tcp -p 6567:6567/udp \
  -v /path/to/config:/mindustry/config \
  --restart unless-stopped \
  mercxry/mindustry:stable
```

### Docker compose (recommended)

```yaml
---
version: "3.8"
services:
  mindustry:
    image: mercxry/mindustry:stable
    container_name: mindustry
    volumes:
      - /path/to/config:/config
    ports:
      - 6567:6567/tcp
      - 6567:6567/udp
    restart: unless-stopped
```

### Connect to console

Attaching to the console is useful to run commands like `host` that will start hosting a game, you won't be able to see previous logs this way as you will be greeted with an empty screen, but you can run commands there.

```sh
docker attach mindustry
```

## Configuration

Configuration for the server can be modified by using commands in the console, the full list of available commands can be found in the [official docs](https://mindustrygame.github.io/wiki/servers/#dedicated-server-configuration-options).

### Auto host

To automatically run the command `host` when starting the server, just run `startCommands host` and the server will host a game the next time you start the container (as long as you keep the same `settings.bin` file).
