#!/bin/sh

sleep 10

BEGIN_SECTION="### BEGIN: Managed by Docker Script ###"
END_SECTION="### END: Managed by Docker Script ###"

# Get the primary IP address of the host.
HOST_IP=$(ip -4 addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)

# Create a temporary hosts file.
TEMP_HOSTS="/tmp/hosts_temp"
cp /etc/hosts $TEMP_HOSTS

# Delete old section if exists and create a new section.
sed -i "/$BEGIN_SECTION/,/$END_SECTION/d" $TEMP_HOSTS
echo "$BEGIN_SECTION" >> $TEMP_HOSTS

# Iterate over all containers.
docker ps --format '{{.Names}}' | while read CONTAINER_NAME; do
    IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_NAME")
    if [[ "$IP" == "0.0.0.0" ]] || [[ -z "$IP" ]]; then
        echo "$HOST_IP $CONTAINER_NAME" >> $TEMP_HOSTS
    else
        echo "$IP $CONTAINER_NAME" >> $TEMP_HOSTS
    fi
done

echo "$END_SECTION" >> $TEMP_HOSTS

# Copy temporary file content over /etc/hosts
cat $TEMP_HOSTS > /etc/hosts

# Infinite loop to keep the script running.
while true; do
    sleep 60
done
