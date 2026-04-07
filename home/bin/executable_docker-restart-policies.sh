#!/bin/bash

# Function to get container info
get_restart_policy() {
    local container_id=$1
    local container_name=$(docker inspect --format '{{ .Name }}' "$container_id" | sed 's/^\///')
    local restart_policy=$(docker inspect --format '{{ .HostConfig.RestartPolicy.Name }}' "$container_id")

    printf "%-15s | %-25s | %-15s\n" "$container_id" "$container_name" "$restart_policy"
}

# Export the function for use in subshells
export -f get_restart_policy

# Header
echo "Container ID    | Name                     | Restart Policy"
echo "------------------------------------------------------------"

# Run in parallel for each container without `-I`
docker ps -q | xargs -n 1 -P 4 bash -c 'get_restart_policy "$0"'
