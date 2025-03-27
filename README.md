# Mininet Docker Project

A containerized environment for running Mininet network emulator, providing an isolated network testing environment with Open vSwitch integration.

## Project Structure

```
mininet-docker/
├── Dockerfile           # Container configuration with Ubuntu 20.04 base
├── docker-compose.yml   # Container orchestration with host networking
├── entrypoint.sh       # Container initialization script
├── .dockerignore       # Docker build exclusions
└── README.md           # Documentation
```

## Prerequisites

- Docker Engine 20.10+
- Docker Compose v2.0+
- Git (for cloning this repository)

## Features

- Ubuntu 20.04 base image
- Automated Mininet installation from source
- Integrated Open vSwitch support
- Host network mode for optimal performance
- Persistent OVS configuration

## Quick Start

### Using Pre-built Image

Pull and run the pre-built image directly:

```bash
# Pull the image
docker pull davidlin123/mininet:latest

# Run with proper configuration
docker run -it --rm \
  --name mininet \
  --privileged \
  --network host \
  -v /lib/modules:/lib/modules \
  davidlin123/mininet:latest
```

### Building from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/davidlin2k/mininet-docker
   cd mininet-docker
   ```

2. Build the container:
   ```bash
   docker compose build
   ```

3. Start the environment:
   ```bash
   docker compose run mininet
   ```

## Container Details

The container includes:
- Python 3 environment
- Open vSwitch service
- Network utilities (iproute2, ping, net-tools)
- Vim editor
- Mininet installed from source

### Network Configuration

- Uses host network mode
- Mounts host's `/lib/modules` for kernel module access
- Runs in privileged mode for network operations

### Initialization Process

The entrypoint script:
1. Starts Open vSwitch service
2. Verifies OVS initialization
3. Configures initial OVS settings
4. Monitors container health

## Usage

### Common Mininet Commands

- Create basic network: `sudo mn`
- Clean up: `sudo mn -c`
- List nodes: `nodes`
- Test connectivity: `pingall`

### Container Management

```bash
# Start container
docker compose run mininet

# View logs
docker compose logs

# Access running container
docker exec -it mininet bash
```

## Troubleshooting

### Common Issues

1. Container fails to start:
   - Verify Docker service: `systemctl status docker`
   - Check OVS status: `service openvswitch-switch status`
   - Review logs: `docker compose logs`

2. Network connectivity issues:
   - Clean Mininet: `sudo mn -c`
   - Verify OVS: `ovs-vsctl show`
   - Check host interfaces: `ip link show`

## License

This project is licensed under the MIT License.
