#!/bin/bash

# Auto Installer for ZYY HOSTING Egg
# Usage: bash <(curl -s https://raw.githubusercontent.com/yourrepo/zyy-egg-installer.sh)

echo "🚀 ZYY HOSTING Egg Auto Installer"
echo "=================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[✓]${NC} $1"
}

error() {
    echo -e "${RED}[✗]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check root
if [ "$EUID" -ne 0 ]; then
    error "Please run as root: sudo bash $0"
    exit 1
fi

# Check panel
if [ ! -d "/var/www/pterodactyl" ]; then
    error "Pterodactyl panel not found in /var/www/pterodactyl"
    echo "Please install Pterodactyl Panel first"
    exit 1
fi

# Egg data
EGG_JSON='{
    "_comment": "DO NOT EDIT: FILE GENERATED AUTOMATICALLY BY PTERODACTYL PANEL - PTERODACTYL.IO",
    "meta": {
        "version": "PTDL_v2",
        "update_url": null
    },
    "exported_at": "2025-10-30T17:55:29+07:00",
    "name": "EGG By ZYY HOSTING 🚀",
    "author": "zyytamvan@zyyhost.my.id",
    "description": null,
    "features": null,
    "docker_images": {
        "ghcr.io/parkervcp/yolks:nodejs_23": "ghcr.io/parkervcp/yolks:nodejs_23",
        "ghcr.io/parkervcp/yolks:nodejs_22": "ghcr.io/parkervcp/yolks:nodejs_22",
        "ghcr.io/parkervcp/yolks:nodejs_21": "ghcr.io/parkervcp/yolks:nodejs_21",
        "ghcr.io/parkervcp/yolks:nodejs_20": "ghcr.io/parkervcp/yolks:nodejs_20",
        "ghcr.io/parkervcp/yolks:nodejs_19": "ghcr.io/parkervcp/yolks:nodejs_19",
        "ghcr.io/parkervcp/yolks:nodejs_18": "ghcr.io/parkervcp/yolks:nodejs_18"
    },
    "file_denylist": [],
    "startup": "if [[ -d .git ]] && [[ {{AUTO_UPDATE}} == \"1\" ]]; then git pull; fi; if [[ ! -z ${NODE_PACKAGES} ]]; then /usr/local/bin/npm install ${NODE_PACKAGES}; fi; if [[ ! -z ${UNNODE_PACKAGES} ]]; then /usr/local/bin/npm uninstall ${UNNODE_PACKAGES}; fi; if [ -f /home/container/package.json ]; then /usr/local/bin/npm install; fi;  if [[ ! -z ${CUSTOM_ENVIRONMENT_VARIABLES} ]]; then      vars=$(echo ${CUSTOM_ENVIRONMENT_VARIABLES} | tr \";\" \"\\n\");      for line in $vars;     do export $line;     done fi;  /usr/local/bin/${CMD_RUN};",
    "config": {
        "files": "{}",
        "startup": "{\r\n    \"done\": \"running\"\r\n}",
        "logs": "{}",
        "stop": "^^C"
    },
    "scripts": {
        "installation": {
            "script": "#!/bin/bash\n# NodeJS App Installation Script\n#\n# Server Files: /mnt/server\napt update\napt install -y git curl jq file unzip make gcc g++ python python-dev libtool\n\nmkdir -p /mnt/server\ncd /mnt/server\n\nif [ \"${USER_UPLOAD}\" == \"true\" ] || [ \"${USER_UPLOAD}\" == \"1\" ]; then\n    echo -e \"assuming user knows what they are doing have a good day.\"\n    exit 0\nfi\n\n## add git ending if it'\''s not on the address\nif [[ ${GIT_ADDRESS} != *.git ]]; then\n    GIT_ADDRESS=${GIT_ADDRESS}.git\nfi\n\nif [ -z \"${USERNAME}\" ] && [ -z \"${ACCESS_TOKEN}\" ]; then\n    echo -e \"using anon api call\"\nelse\n    GIT_ADDRESS=\"https://${USERNAME}:${ACCESS_TOKEN}@$(echo -e ${GIT_ADDRESS} | cut -d/ -f3-)\"\nfi\n\n## pull git js repo\nif [ \"$(ls -A /mnt/server)\" ]; then\n    echo -e \"/mnt/server directory is not empty.\"\n    if [ -d .git ]; then\n        echo -e \".git directory exists\"\n        if [ -f .git/config ]; then\n            echo -e \"loading info from git config\"\n            ORIGIN=$(git config --get remote.origin.url)\n        else\n            echo -e \"files found with no git config\"\n            echo -e \"closing out without touching things to not break anything\"\n            exit 10\n        fi\n    fi\n\n    if [ \"${ORIGIN}\" == \"${GIT_ADDRESS}\" ]; then\n        echo \"pulling latest from github\"\n        git pull\n    fi\nelse\n    echo -e \"/mnt/server is empty.\\ncloning files into repo\"\n    if [ -z ${BRANCH} ]; then\n        echo -e \"cloning default branch\"\n        git clone ${GIT_ADDRESS} .\n    else\n        echo -e \"cloning ${BRANCH}'\"\n        git clone --single-branch --branch ${BRANCH} ${GIT_ADDRESS} .\n    fi\n\nfi\n\necho \"Installing nodejs packages\"\nif [[ ! -z ${NODE_PACKAGES} ]]; then\n    /usr/local/bin/npm install ${NODE_PACKAGES}\nfi\n\nif [ -f /mnt/server/package.json ]; then\n    /usr/local/bin/npm install --production\nfi\n\necho -e \"install complete\"\nexit 0",
            "container": "node:14-buster-slim",
            "entrypoint": "bash"
        }
    },
    "variables": [
        {
            "name": "Git Repo Address",
            "description": "GitHub Repo to clone\r\n\r\nI.E. https://github.com/user_name/repo_name",
            "env_variable": "GIT_ADDRESS",
            "default_value": "",
            "user_viewable": true,
            "user_editable": true,
            "rules": "nullable|string",
            "field_type": "text"
        },
        {
            "name": "Install Branch",
            "description": "The branch to install.",
            "env_variable": "BRANCH",
            "default_value": "",
            "user_viewable": true,
            "user_editable": true,
            "rules": "nullable|string",
            "field_type": "text"
        },
        {
            "name": "Git Username",
            "description": "Username to auth with git.",
            "env_variable": "USERNAME",
            "default_value": "",
            "user_viewable": true,
            "user_editable": true,
            "rules": "nullable|string",
            "field_type": "text"
        },
        {
            "name": "Git Access Token",
            "description": "Password to use with git.\r\n\r\nIt'\''s best practice to use a Personal Access Token.\r\nhttps://github.com/settings/tokens\r\nhttps://gitlab.com/-/profile/personal_access_tokens",
            "env_variable": "ACCESS_TOKEN",
            "default_value": "",
            "user_viewable": true,
            "user_editable": true,
            "rules": "nullable|string",
            "field_type": "text"
        },
        {
            "name": "Command Run",
            "description": "The command to start the bot",
            "env_variable": "CMD_RUN",
            "default_value": "npm start",
            "user_viewable": true,
            "user_editable": true,
            "rules": "required|string",
            "field_type": "text"
        }
    ]
}'

log "Creating egg file..."
echo "$EGG_JSON" > /tmp/zyy_nodejs_egg.json

log "Changing to panel directory..."
cd /var/www/pterodactyl

log "Importing ZYY HOSTING Egg..."
php artisan p:egg:import /tmp/zyy_nodejs_egg.json

if [ $? -eq 0 ]; then
    log "Egg imported successfully!"
    
    log "Cleaning up..."
    rm -f /tmp/zyy_nodejs_egg.json
    
    log "Listing installed eggs:"
    php artisan p:egg:list
    
    echo ""
    log "🎉 ZYY HOSTING Egg installed successfully!"
    log "🥚 Name: EGG By ZYY HOSTING 🚀"
    log "👤 Author: zyytamvan@zyyhost.my.id"
    log "🐳 Supports: NodeJS 18-23"
else
    error "Failed to import egg"
    exit 1
fi