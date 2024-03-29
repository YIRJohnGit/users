#!/bin/bash

# ANSI color codes
red='\033[0;31m'
yellow='\033[1;33m'
green='\033[0;32m'
nc='\033[0m' # No Color

# Function to print in red
print_error() {
    echo -e "${red}$1${nc}"
}

# Function to print in yellow
print_warning() {
    echo -e "${yellow}$1${nc}"
}

# Function to print in green
print_success() {
    echo -e "${green}$1${nc}"
}

# Function to read user input with a prompt
read_input() {
    read -p "$1: " input
    echo "$input"
}

# Validate domain name
validate_domain() {
    domain=$1
    if [[ ! $domain =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        print_error "Invalid domain name. Please enter a valid domain name."
        exit 1
    fi
}

# Ask for domain name
while true; do
    domain=$(read_input "Enter your domain name")
    validate_domain "$domain" && break
done

# Validate document root path
validate_document_root() {
    document_root=$1
    if [[ ! -d $document_root ]]; then
        print_error "Invalid document root path. Please enter a valid path."
        exit 1
    fi
}

# Ask for document root path
while true; do
    document_root=$(read_input "Enter the document root path for your domain [/home/devops.purtainet.com/public_html] ")
    validate_document_root "$document_root" && break
done

# Ask if "www" should be added to the domain
read -p "Do you want to add 'www' to your domain? (y/n): " add_www




# Define the webroot directory
WEBROOT_DIR="${document_root}"

# Create the .well-known/acme-challenge directory
mkdir -p "$WEBROOT_DIR/.well-known/acme-challenge"

# Add a test file to verify access
echo "This is a test file to verify access" > "$WEBROOT_DIR/.well-known/acme-challenge/test.txt"

# Start a simple web server to serve the files
python3 -m http.server 80 --directory "$WEBROOT_DIR/.well-known/acme-challenge"







if [[ $add_www == "y" ]]; then
  # sudo certbot certonly --webroot -v --cert-name $domain --domains $domain --domains www.$domain --agree-tos --no-eff-email --email admin@$domain --hsts --uir --webroot-path $document_root --rsa-key-size 2048 --non-interactive --preferred-challenges http
  # sudo certbot certonly --webroot -v --cert-name $domain --domains $domain --domains www.$domain --agree-tos --no-eff-email --email yirjohn@gmail.com --hsts --uir --webroot-path $document_root --rsa-key-size 2048 --non-interactive --preferred-challenges http --cert-request "-subj '/C=IN/ST=Karnataka/L=Bengaluru/O=MN Service Providers/OU=IT Solutions/CN=$domain'"
  sudo certbot certonly --webroot -v --cert-name $domain --domains $domain --domains www.$domain --agree-tos --no-eff-email --email yirjohn@gmail.com --hsts --uir --webroot-path $document_root --rsa-key-size 2048 --non-interactive --preferred-challenges http --csr <(openssl req -new -newkey rsa:2048 -nodes -keyout /etc/letsencrypt/live/$domain/privkey.pem -out /etc/letsencrypt/live/$domain/csr.pem -subj "/C=IN/ST=Karnataka/L=Bengaluru/O=MN Service Providers/OU=IT Solutions/CN=$domain")

  
  # sudo certbot certonly --webroot -v --cert-name $domain --domains $domain --domains www.$domain --agree-tos --no-eff-email --email yirjohn@gmail.com --hsts --uir --webroot-path $document_root --rsa-key-size 2048 --non-interactive --preferred-challenges http --csr <(openssl req -new -newkey rsa:2048 -nodes -keyout /path/to/domain.key -out /path/to/domain.csr -subj "/C=IN/ST=Karnataka/L=Bengaluru/O=MN Service Providers/OU=IT Solutions/CN=$domain")

  # sudo certbot certonly --webroot -v --cert-name $domain --domains $domain --domains www.$domain --agree-tos --no-eff-email --email yirjohn@gmail.com --hsts --uir --webroot-path $document_root --rsa-key-size 2048 --non-interactive --preferred-challenges http --csr <(openssl req -new -newkey rsa:2048 -nodes -keyout /path/to/domain.key -out /path/to/domain.csr -subj "/C=IN/ST=Karnataka/L=Bengaluru/O=MN Service Providers/OU=IT Solutions/CN=devops.purtainet.com")

  print_success "Certificate obtained successfully!"
elif [[ $add_www == "n" ]]; then
  sudo certbot certonly --webroot -v --cert-name $domain --domains $domain --agree-tos --no-eff-email --email admin@$domain --hsts --uir --webroot-path $document_root --rsa-key-size 2048 --non-interactive --preferred-challenges http
  print_success "Certificate obtained successfully!"
else
  print_error "Error executing certbot command. Please check your inputs and try again."
fi
