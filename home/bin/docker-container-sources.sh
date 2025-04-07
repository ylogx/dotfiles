#!/bin/bash
# bin/docker-container-source.sh | sort -t '|' -k 3

echo "Container ID    | Name                     | Source Path"
echo "------------------------------------------------------------"

# Function to extract source information for each container
get_container_source_info() {
    local container_id=$1
    local container_name=$(docker inspect --format '{{ .Name }}' "$container_id" | sed 's/^\///')
    local compose_file=""
    local dockerfile=""

    # Check for Docker Compose labels or environment variables
    compose_file=$(docker inspect --format '{{ index .Config.Labels "com.docker.compose.project.working_dir" }}' "$container_id")

    # Check mounts for possible Dockerfile paths or volume binds
    dockerfile=$(docker inspect --format '{{ range .Mounts }}{{ if eq .Type "bind" }}{{ .Source }}{{ end }} {{ end }}' "$container_id")

    # Determine the source path based on available info
    if [ -n "$compose_file" ]; then
        source_path="$compose_file/docker-compose.yml"
    elif [ -n "$dockerfile" ]; then
        source_path="$dockerfile/Dockerfile"
    else
        source_path="Unknown"
    fi

    # Print out container details
    printf "%-15s | %-25s | %-40s\n" "$container_id" "$container_name" "$source_path"
}

# Loop over each container and get source information
docker ps -q | while read container_id; do
    get_container_source_info "$container_id"
done
