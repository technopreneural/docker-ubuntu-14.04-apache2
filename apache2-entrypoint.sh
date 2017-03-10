#!/bin/bash
# Ensure apache run directory exists
if [ ! -d "$APACHE_RUN_DIR" ]; then
	mkdir "$APACHE_RUN_DIR"
	chown $APACHE_RUN_USER:$APACHE_RUN_GROUP "$APACHE_RUN_DIR"
fi

# Remove stale PIDFile
if [ -f "$APACHE_PID_FILE" ]; then
	rm "$APACHE_PID_FILE"
fi

# Ensure site repo is specified
function repo_is_specified {
	if [ -z ${APACHE_SITE_REPO+x} ];
	then 
		echo "$APACHE_SITE_REPO is not defined.";
		exit -1;
	else 
		exit 0;
	fi
}

# Ensure site repo is accessible
function repo_is_accessible {
	git ls-remote -h $APACHE_SITE_REPO &> /dev/null;
	if [ $? -eq 0 ];
	then exit 0;
	else exit -1;
	fi
}

# Ensure target site exists
function site_exists {
	git clone $APACHE_SITE_REPO /var/www;
	if [ $? -eq 0 ];
	then exit -1;
	fi
}

# Ensure target site is updated
function site_is_updated {
	local REPO_DIR=basename ${APACHE_SITE_REPO%.*} 
	git -C /var/www/$REPO_DIR diff-index
}

/usr/sbin/apache2ctl -D FOREGROUND
