#!/bin/bash
echo "🥚 Starting Auto Egg & Nest Setup"

# Check panel directory
if [ ! -d "/var/www/pterodactyl" ]; then
    echo "❌ Pterodactyl panel not found!"
    exit 1
fi

cd /var/www/pterodactyl

# Create nest first
echo "📁 Creating Nest..."
NEST_NAME="ZYY Applications"
php artisan p:nest:create --name="$NEST_NAME" --description="Auto created nest for applications"

# Create egg file
echo "📦 Creating Egg..."
cat > /tmp/zyy_egg.json << 'EOF'
{
    _comment": "DO NOT EDIT: FILE GENERATED AUTOMATICALLY BY PTERODACTYL PANEL - PTERODACTYL.IO",
    "meta": {
        "version": "PTDL_v2",
        "update_url": null
    },
    "exported_at": "2025-10-30T17:55:29+07:00",
    "name": "EGG By ZYY HOSTING",
    "author": "zyytamvan@zyyhost.my.id",
    "description": "NodeJS Egg for ZYY HOSTING",
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
            "script": "#!/bin/bash\napt update\napt install -y git curl jq file unzip make gcc g++ python python-dev libtool\nmkdir -p /mnt/server\ncd /mnt/server\nif [ \"${USER_UPLOAD}\" == \"true\" ] || [ \"${USER_UPLOAD}\" == \"1\" ]; then\n    echo -e \"assuming user knows what they are doing have a good day.\"\n    exit 0\nfi\nif [[ ${GIT_ADDRESS} != *.git ]]; then\n    GIT_ADDRESS=${GIT_ADDRESS}.git\nfi\nif [ -z \"${USERNAME}\" ] && [ -z \"${ACCESS_TOKEN}\" ]; then\n    echo -e \"using anon api call\"\nelse\n    GIT_ADDRESS=\"https://${USERNAME}:${ACCESS_TOKEN}@$(echo -e ${GIT_ADDRESS} | cut -d/ -f3-)\"\nfi\nif [ \"$(ls -A /mnt/server)\" ]; then\n    echo -e \"/mnt/server directory is not empty.\"\n    if [ -d .git ]; then\n        echo -e \".git directory exists\"\n        if [ -f .git/config ]; then\n            echo -e \"loading info from git config\"\n            ORIGIN=$(git config --get remote.origin.url)\n        else\n            echo -e \"files found with no git config\"\n            echo -e \"closing out without touching things to not break anything\"\n            exit 10\n        fi\n    fi\n    if [ \"${ORIGIN}\" == \"${GIT_ADDRESS}\" ]; then\n        echo \"pulling latest from github\"\n        git pull\n    fi\nelse\n    echo -e \"/mnt/server is empty.\\ncloning files into repo\"\n    if [ -z ${BRANCH} ]; then\n        echo -e \"cloning default branch\"\n        git clone ${GIT_ADDRESS} .\n    else\n        echo -e \"cloning ${BRANCH}'\"\n        git clone --single-branch --branch ${BRANCH} ${GIT_ADDRESS} .\n    fi\nfi\necho \"Installing nodejs packages\"\nif [[ ! -z ${NODE_PACKAGES} ]]; then\n    /usr/local/bin/npm install ${NODE_PACKAGES}\nfi\nif [ -f /mnt/server/package.json ]; then\n    /usr/local/bin/npm install --production\nfi\necho -e \"install complete\"\nexit 0",
            "container": "node:14-buster-slim",
            "entrypoint": "bash"
        }
    },
    "variables": [
        {
            "name": "Git Repo Address",
            "description": "GitHub Repo to clone",
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
            "description": "Password to use with git.",
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
}
EOF

# Import egg
php artisan p:egg:import /tmp/zyy_egg.json

# Cleanup
rm -f /tmp/zyy_egg.json

echo "✅ Setup Completed!"
echo "📁 Nest: $NEST_NAME"
echo "🥚 Egg: ZYY NodeJS App"