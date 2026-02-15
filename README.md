# headless
Run a GNU/Linux distribution with a GUI inside a Docker container to run your graphical applications with as few resources as possible.

Access the desktop through **VNC** (port `5901`) or directly in your **browser** via **noVNC** (port `6901`).

---

## Available Images

| Image | Base |
|---|---|
| `hudsonventura/headless:ubuntu_24.04` | Ubuntu 24.04 LTS |

---

## Quick Start

Create a `docker-compose.yml` file:

```yaml
services:
  headless:
    image: hudsonventura/headless:ubuntu_24.04
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

## Building from Source

Clone the repository:

```bash
git clone https://github.com/hudsonventura/headless.git
cd headless
```

Build the image:

```bash
docker compose build
```

Run it:

```bash
docker compose up -d
```

---

## License

This project is licensed under the terms of the [GPL-3.0 license](LICENSE).
