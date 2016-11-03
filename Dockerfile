FROM		ubuntu:14.04
MAINTAINER	technopreneural@yahoo.com

# Create volume for host folder
# NOTE: use "docker run -v <folder_path>:<volume>..." to bind volume to host folder
VOLUME		["/var/mysql/data"]

# Expose port 80 and 443 (HTTP and HTTPS/SSL) to other containers
# NOTE: use "docker run -p 80:80 -p 443:443..." to map exposed port(s) to host ports
EXPOSE 	80

# Enable (or disable) apt-cache proxy
#ENV		http_proxy http://acng.robin.dev:3142

# Install packages
RUN		apt-get update \
		&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
			debconf-utils \
			apache2 \
			apache2-utils \

# Fix warnings
		&& echo "ServerName localhost" >> /etc/apache2/conf-available/servername.conf && a2enconf servername

ENTRYPOINT		["/usr/sbin/apache2ctl", "-D FOREGROUND"]
