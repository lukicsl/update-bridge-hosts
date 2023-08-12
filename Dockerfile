 
#Use an official base image
FROM docker:stable-dind

# Set the working directory in the container
WORKDIR /config

# Copy the update_hosts.sh script to the container
COPY update_hosts.sh /config/update_hosts.sh

# Make the script executable
RUN chmod +x /config/update_hosts.sh

# Specify the default command to run the script
CMD ["/config/update_hosts.sh"]

