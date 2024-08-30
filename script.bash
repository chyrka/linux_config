#!/bin/bash

# Determine the Apache configuration file path depending on the distribution
if command -v apache2 &> /dev/null; then
    APACHE_CONF="/etc/apache2/apache2.conf"
elif command -v httpd &> /dev/null; then
    APACHE_CONF="/etc/httpd/conf/httpd.conf"
else
    echo "Apache is not installed on this system."
    exit 1
fi

# Add configuration to the config file if it's not already present
if ! grep -q "ServerSignature Off" "$APACHE_CONF"; then
    echo "Adding settings to $APACHE_CONF"
    echo "" >> "$APACHE_CONF"
    echo "# Security settings added" >> "$APACHE_CONF"
    echo "ServerSignature Off" >> "$APACHE_CONF"
    echo "ServerTokens Prod" >> "$APACHE_CONF"
    echo "TraceEnable Off" >> "$APACHE_CONF"
else
    echo "Settings already present in $APACHE_CONF"
fi

# Restart Apache to apply the new settings
echo "Restarting Apache..."
if command -v systemctl &> /dev/null; then
    sudo systemctl restart apache2 || sudo systemctl restart httpd
else
    sudo service apache2 restart || sudo service httpd restart
fi

# Display the curl command for manual checking
echo "Please manually check if the web server version is displayed by running the following command:"
echo "curl --head http://localhost"
