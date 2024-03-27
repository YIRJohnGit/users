#!/bin/bash

# Function to display colored messages
color_echo() 
{
    case "$1" in
        red)    echo -e "\e[91m$2\e[0m";;
        green)  echo -e "\e[92m$2\e[0m";;
        yellow) echo -e "\e[93m$2\e[0m";;
        *)      echo "$2";;
    esac
}

# Function to create Apache configuration
create_apache_config() 
{
    local domain_name="$1"
    local folder_location="$2"
    local user_name="$3"

    local http_config="$domain_name.conf"

    if [ -e "$http_config" ]; then
        color_echo "red" "Error: Configuration file for HTTP already exists. Aborting. ($http_config)"
        return 1
    fi

    # HTTP Configuration
    {
        echo "# Virtual Host Configuration for HTTP generated from YIR John Script"
        echo "<VirtualHost *:80>"
        echo "    ServerAdmin admin@$domain_name"
        echo "    ServerName $domain_name"
        echo "    ServerAlias www.$domain_name"
        echo ""
        echo "    DocumentRoot $folder_location/public_html"
        echo "    DirectoryIndex index.htm index.html index.shtml index.php index.phtml"
        echo ""
        echo "    <Directory \"$folder_location/public_html\">"
        echo "        Options Indexes FollowSymLinks"
        echo "        AllowOverride All"
        echo "        Require all granted"
        echo "    </Directory>"
        echo ""

        echo ""
        echo "    ErrorLog $folder_location/logs/error.log"
        echo "    CustomLog $folder_location/logs/access.log combined"
        echo ""
        
        echo "</VirtualHost>"
    } > "$http_config"
