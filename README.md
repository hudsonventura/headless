# headless
Run a GNU/Linux distribution with a GUI inside a Docker container to run your graphical applications with as few resources as possible.

Access the desktop through **VNC** (port `5901`) or directly in your **browser** via **noVNC** (port `6901`).

# Stack

- **GUI**: Openbox https://openbox.org
- **VNC Server**: TigerVNC https://www.tigervnc.org/
- **VNC Web Interface**: noVNC https://github.com/novnc/noVNC

---

## Available Images

### Debian Based
| Image | Base | Image Size | RAM Consumption |
|---|---|---|---|
| `hudsonventura/headless:ubuntu_24.04` | Ubuntu 24.04 LTS | 879MB |  ~ 52MB


### RHEL Based
| Image | Base | Image Size | RAM Consumption |
|---|---|---|---|
| `hudsonventura/headless:almalinux_9`  | AlmaLinux 9   | 957MB | ~ 44MB |
| `hudsonventura/headless:rockylinux_9` | Rocky Linux 9 | 1.11GB | ~ 45MB |



---

## Quick Start

Create a `docker-compose.yml` file:

```yaml
services:
  headless:
    # Choose your base
    image: hudsonventura/headless:ubuntu_24.04
    #image: hudsonventura/headless:almalinux_9
    #image: hudsonventura/headless:rockylinux_9
    
    ports:
      - "5901:5901"
      - "6901:6901"
    environment:
      - VNC_PW=password
      - SCREEN_RESOLUTION=1280x720
    restart: unless-stopped
```

Then start it:

```bash
docker compose up -d
```

Now access the desktop:

- **Browser (noVNC):** [http://localhost:6901/vnc.html](http://localhost:6901/vnc.html)
- **VNC client:** `localhost:5901`
- **Password:** `password` (or whatever you set in `VNC_PW`)

To stop:

```bash
docker compose down
```

## Use to build your image
Those image is to you generate your own images.  
ForHow example, create a file `Dockerfile` and put this content to create a container with Firefox:
```Dockerfile
FROM hudsonventura/headless:ubuntu_24.04

# Add your applications here
RUN apt-get update && apt-get install -y \
    firefox \
    && rm -rf /var/lib/apt/lists/*
```

## Examples
At the dir `examples` you can find some examples of how to use this image.  
For example, create a file `docker-compose.yml` and put this content to create a container with Google Chrome. It will start Google Chrome automatically inside the container. If Chrome stopes, the container stops as well.
```yaml
services:

  chromium-test:
    build:
      context: ./
      dockerfile: Dockerfile
    ports:
      - "5901:5901"
      - "6901:6901"
    environment:
      - VNC_PW=password
      - SCREEN_RESOLUTION=1280x720
    restart: unless-stopped

    # The command below wait the X server to be ready and then start the chrome. If chrome closes, the container will restart.
    command: >
      sh -c "/start.sh &
            until xdpyinfo -display :1 >/dev/null 2>&1; do
              echo 'Waiting for X...';
              sleep 1;
            done;
            DISPLAY=:1 google-chrome --no-sandbox"
```


Create a file `Dockerfile` and put this content:
```dockerfile
FROM hudsonventura/headless:ubuntu_24.04


RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    sudo apt update

RUN sudo apt install -y fonts-liberation libasound2t64 libnspr4 libnss3 xdg-utils && \
    sudo apt install -y ./google-chrome-stable_current_amd64.deb*

# Wrap Google Chrome to run with --no-sandbox to avoid needing privileged container modes
RUN sudo mv /usr/bin/google-chrome-stable /usr/bin/google-chrome-stable.real && \
    printf '#!/bin/bash\nexec /usr/bin/google-chrome-stable.real --no-sandbox --disable-dev-shm-usage "$@"\n' | sudo tee /usr/bin/google-chrome-stable && \
    sudo chmod +x /usr/bin/google-chrome-stable
```
---

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `VNC_PW` | `password` | Password for VNC connection |
| `SCREEN_RESOLUTION` | `1280x720` | Screen resolution (e.g. `1920x1080`, `1280x720`) |

---

## Ports

| Port | Service |
|---|---|
| `5901` | VNC server (connect with any VNC client) |
| `6901` | noVNC web client (access via browser) |



---

## License

This project is licensed under the terms of the [GPL-3.0 license](LICENSE).
