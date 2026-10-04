#!/bin/bash
set -e

# colors
GREEN="\e[1;32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

# Exit immediately if not Trixie
echo -e "${GREEN}checking if debian 13${RESET}"
. /etc/os-release
[ "$VERSION_CODENAME" = "trixie" ] || { echo -e "Error: Requires Debian Trixie"; exit 1; }
echo "done"

# backup sources
echo -e "${GREEN}backing up sources${RESET}"
cp -a /etc/apt/sources.list.d/debian.sources "/root/debian.sources.$(date +%Y%m%d-%H%M%S).bak"
echo "done"

echo -e "${GREEN}adding non free repo...${RESET}"
# configure Debian 13 (Trixie) repositories with non-free components
cat << 'EOF' > /etc/apt/sources.list.d/debian.sources
Types: deb deb-src
URIs: https://deb.debian.org/debian
Suites: trixie trixie-updates
Components: main contrib non-free non-free-firmware
Enabled: yes
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb deb-src
URIs: https://security.debian.org/debian-security
Suites: trixie-security
Components: main contrib non-free non-free-firmware
Enabled: yes
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF
echo "done"

# packages
echo -e "${GREEN}installing libs...${RESET}"
apt install -y extrepo curl wget screen
echo "done"
echo -e "${GREEN}adding i386 architecture...${RESET}"
dpkg --add-architecture i386
echo "done"
echo -e "${GREEN}updating...${RESET}"
apt update
echo "done"
echo -e steam steam/question select "I AGREE" | debconf-set-selections
echo -e steam steam/license note "" | debconf-set-selections
echo -e "${GREEN}installing steamcmd...${RESET}"
apt install -y steamcmd
echo "done"
echo -e "${GREEN}updating & upgrading...${RESET}"
apt update && apt upgrade -y
echo "done"
echo -e "${GREEN}steamcmd installation location: /usr/games/steamcmd"
echo -e "updating steamcmd${RESET}"
/usr/games/steamcmd +exit
echo "done"
#echo -e "${GREEN}add temp alias${RESET}"
#alias steamcmd='/usr/games/steamcmd'
#echo "done"

# optional install game section
echo ""
echo "Find game here:"
echo -e "${YELLOW}https://steamdb.info${RESET}"
#echo -e "steamcmd +login anonymous +force_install_dir /home/steam/Valheim +app_update 896660 validate +exit"
#echo -e "In place of Valheim put game name, in place of 896660 use corresponding game ID found here https://steamdb.info/"

# automation
# ask for Game name:
echo -e "Does not have to be exact, something easy."
echo -e "For example: Call of Duty 4: Modern Warfare (2007) can be called 'COD4'"
read -p "Game name? " game_choice
# ask for ID:
echo -e "${RED}Has to be exact.${RESET}"
echo "Use AppID straight from SteamDB."
read -p "App ID? " app_id
# debug
#echo -e "${game_choice}"  "${app_id}"

# install game
echo "#{GREEN}Running: steamcmd +login anonymous +force_install_dir \"/home/steam/${game_choice}\" +app_update \"${app_id}\" validate +exit"
/usr/games/steamcmd +login anonymous +force_install_dir "/home/steam/${game_name}" +app_update "${app_id}" validate +exit
