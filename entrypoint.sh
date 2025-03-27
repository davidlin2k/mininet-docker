#!/bin/bash
set -e

# Function for logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Handle termination signals
trap 'log "Received SIGTERM or SIGINT, shutting down..."; service openvswitch-switch stop; exit 0' TERM INT

# Startup message
log "Starting Mininet Docker container..."

# Start Open vSwitch service
log "Starting Open vSwitch service..."
service openvswitch-switch start || {
    log "ERROR: Failed to start Open vSwitch service"
    exit 1
}

# Wait for OVS to initialize with timeout and check
ovs_ready=false
max_retries=10
retry_count=0

while [ $retry_count -lt $max_retries ]; do
    if ovs-vsctl show &>/dev/null; then
        ovs_ready=true
        break
    fi
    log "Waiting for OVS to initialize (attempt $((retry_count+1))/$max_retries)..."
    sleep 1
    retry_count=$((retry_count+1))
done

if [ "$ovs_ready" = false ]; then
    log "ERROR: OVS failed to initialize within the allowed time"
    exit 1
fi

# Initialize the database if this is the first run
if ! ovs-vsctl br-exists br0 &>/dev/null; then
    log "Configuring initial OVS settings..."
    ovs-vsctl --no-wait init
fi

# Print OVS status
log "Open vSwitch is running with the following configuration:"
ovs-vsctl show

# Execute the command passed to docker
log "Initialization complete, executing command: $@"
exec "$@"
