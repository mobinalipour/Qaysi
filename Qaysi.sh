#!/bin/bash


AUTHOR="[mobin-alipour](https://github.com/mobinalipour)"
VERSION="1.0.0"


#
# DATA CREATED : 2023-10-24
# Author : Mobin Alipour
# Github : https://github.com/mobinalipour
# Named to : Qaysi (My orange cat name)
#
#
# Description : 
#   This script starts reverse SSH tunnle between two servers.
#   The purpose for creating is make it more easy for non tecnical users :)
#
#
# Usage : bash ./Qaysi.sh
#
#
# Thanks to : 
#   [mohammad hossein gholi nasab](https://github.com/slayer76)
#
#


# Colors we are using
red="\e[31m\e[01m"
blue="\e[36m\e[01m"
green="\e[32m\e[01m"
yellow="\e[33m\e[01m"
bYellow="\e[1;33m"
no_color="\e[0m"


# Ascii art for the author name
function ascii_art() {
  echo -e "
   __  __  ___  ____ ___ _   _      _    _     ___ ____   ___  _   _ ____  
  |  \/  |/ _ \| __ )_ _| \ | |    / \  | |   |_ _|  _ \ / _ \| | | |  _ \  
  | |\/| | | | |  _ \| ||  \| |   / _ \ | |    | || |_) | | | | | | | |_) | 
  | |  | | |_| | |_) | || |\  |  / ___ \| |___ | ||  __/| |_| | |_| |  _ <  
  |_|  |_|\___/|____/___|_| \_| /_/   \_\_____|___|_|    \___/ \___/|_| \_\ 
  +------------------------------------------------------------------------+
  "
}



# ********** Variables **********
# General Variables
CAN_USE_TPUT=$(command -v tput >/dev/null 2>&1 && echo "true" || echo "false")
SPIN_TEXT_LEN=0
SPIN_PID=
SERVICE_NAME=Qaysi

# Status Variables
# STEP_STATUS ==>  (0: failed) | (1: success) 
STEP_STATUS=1

# OS Variables
PKG_UPDATE=("apt -y update")
PKG_INSTALL=("apt -y --fix-broken install sshpass")



# *********** Message ***********
declare -A V

# intro
V[000]="Thanks for using this script \n  If you found this script useful: \n  Please support me by a star on my Github! :)"
V[001]="Version:"
V[002]="Author:"
V[003]="Notes:"
V[004]="The script will ask you the ports you want to reverse tunnel \n    But if someday you want to add more ports to get tunneled just run this two commands:"
V[005]="systemctl start Qaysi@the_port_you_want \n    systemctl enable Qaysi@the_port_you_want"
V[006]="OR Just run this script one more time to add more ports :)) "
# base
V[010]="Error" 
# check_root
V[020]="Verifying root access..."
V[021]="Please run this script as root!"
V[022]="Great News! You have Superuser privileges. Let's continue..."
# install_base_packages
V[023]="Installing essential packages for your OS..."
V[024]="There was an error during the installation of essential packages! \n  Please check your connection or try again later."
V[025]="All required packages have been successfully installed."
# user info
V[026]="Thanks for info, the proccess is going on..."
V[027]="Reverse tunnel is successful"
V[028]="please enter ports you want to reverse tunnel and seprate by space!"
V[029]="Enter ports"
V[030]="please enter your free server ip address!"
V[031]="Enter ip"
V[032]="please enter your free server username!"
V[033]="Enter username"
V[034]="please enter your free server Password!"
V[035]="Enter Password"
# ssh 
V[036]="Going to create an SSH key and copy to your free server..."
V[037]="✅ Nice, Creating SSH key and logging in into free server was successfull!"
V[038]="There was an error during SSH to free server! \n  please check your free server ip and password ..."
# systemd service
V[039]="Now, going to create systemd service and tunnel your ports"
V[040]="✅ Everything gone great, service created and tunnel is ready to use :) \n     "
V[041]="There was an error during create service and tunnel! \n  please run script again..."
V[042]="ports has been tunneled :"
V[048]="\n     service name is : "
# cronjob user info
V[043]="please enter a number between 1 and 59 to restart tunnel every x minute:"
V[044]="Enter number"
# set cronjob
V[045]="Now we are setting cronjob..."
V[046]="✅ Good News! The cron job has been set \n     All steps completed successfully, please do not forget to reboot \n     See you later :)"
V[047]="there was an error during setting cronjob! \n   please run script again..."



# *********** Functions ***********
function draw_line() {

  local line=""
  local width=$(( ${COLUMNS:-${CAN_USE_TPUT:+$(tput cols)}} ))
  line=$(printf "%*s" "${width}" | tr ' ' '_')
  echo "${line}"

}



function escaped_length() {

  # escape color from string
  local str="${1}"
  local stripped_len=$(echo -e "${str}" | sed 's|\x1B\[[0-9;]\{1,\}[A-Za-z]||g' | tr '\n' ' ' | wc -m)
  echo "${stripped_len}"

}



function run_step() {

  {
    "$@"
  } &> /dev/null

}



# Spinner Function
function start_spin() {

  local spin_chars='/-\|'
  local sc=0
  local delay=0.1
  local text="${1}"
  SPIN_TEXT_LEN=$(escaped_length "${text}")
  # Hide cursor
  [[ "${CAN_USE_TPUT}" == "true" ]] && tput civis
  while true; do
    printf "\r  [%s] ${text}"  "${spin_chars:sc++:1}"
    sleep ${delay}
    ((sc==${#spin_chars})) && sc=0
  done &
  SPIN_PID=$!
  # Show cursor
  [[ "${CAN_USE_TPUT}" == "true" ]] && tput cnorm

}



function kill_spin() {

  kill "${SPIN_PID}"
  wait "${SPIN_PID}" 2>/dev/null

}



function end_spin() {

  local text="${1}"
  local text_len=$(escaped_length "${text}")
  run_step "kill_spin"
  if [[ -n "${text}" ]]; then
    printf "\r  ${text}"
    # Due to the preceding space in the text, we append '6' to the total length.
    printf "%*s\n" $((${SPIN_TEXT_LEN} - ${text_len} + 6)) ""
  fi
  # Reset Status
  STEP_STATUS=1

}



# Clean up if script terminated.
function clean_up() {
  # Show cursor && Kill spinner
  [[ "${CAN_USE_TPUT}" == "true" ]] && tput cnorm
  end_spin ""
}
trap clean_up EXIT TERM SIGHUP SIGTERM



function check_root() {

  start_spin "${yellow}${V[020]}${no_color}"
  [[ $EUID -ne 0 ]] && end_spin "${red}${V[010]} ${V[021]}${no_color}" && exit 1
  end_spin "${green}${V[022]}${no_color}"

}



function intro() {

  echo -e "${blue}
$(draw_line)
$(draw_line)
$(ascii_art)
${no_color}
  ${green}${V[001]}${no_color} ${bYellow}${VERSION}${no_color}
  ${green}${V[002]}${no_color} ${bYellow}${AUTHOR}${no_color}
  
  ${blue}${V[000]}${no_color}

  ${red}${V[003]}${no_color}
    ${green}${V[004]}${no_color}
    ${bYellow}${V[005]}${no_color}
    ${blue}${V[006]}${no_color}


${blue}
$(draw_line)
$(draw_line)
${no_color}"

}



function step_install_pkgs() {

  {
        ${PKG_UPDATE}
        ${PKG_INSTALL} wget net-tools
  }
  [[ $? -ne 0 ]] && STEP_STATUS=0

}



function install_base_packages() {

  start_spin "${yellow}${V[023]}${no_color}"
  run_step "step_install_pkgs"
  if [[ "${STEP_STATUS}" -eq 0 ]]; then
    end_spin "${red}${V[010]} ${V[024]}${no_color} \n " && exit 1
  fi
  end_spin "${green}${V[025]}${no_color} \n "

}



function user_info() {

  read -p "$(echo -e $'  '${green}${V[030]}${no_color} ${bYellow} for example: 1.1.1.1 $'\n  > '  ${V[031]} : )" free_server_ip
  echo " "
  read -p "$(echo -e $'  '${green}${V[032]}${no_color} ${bYellow} for example: root $'\n  > '  ${V[033]} : )" free_server_user
  echo " "
  read -p "$(echo -e $'  '${green}${V[034]}${no_color} ${bYellow} $'\n  > '  ${V[035]} : )" free_server_password
  echo " "
  read -a ports -p "$(echo -e $'  '${green}${V[028]}${no_color} ${bYellow} for example: 1770 1771 1772 ... $'\n  > '  ${V[029]} $'(between 1 and 65535)' : )"
  echo " "
  read -p "$(echo -e $'  '${green}${V[043]}${no_color} ${bYellow} $'\n  > '  ${V[044]} : )" cron_minutes
  echo " "
  clear
  intro
}



function step_ssh_to_free_server() {

ssh-keygen -t rsa -f /root/.ssh/id_rsa -N '' <<< yes
sshpass -p $free_server_password ssh-copy-id -i ~/.ssh/id_rsa.pub $free_server_user@$free_server_ip
ssh $free_server_user@$free_server_ip << EOF
echo "GatewayPorts yes" >> /etc/ssh/sshd_config
systemctl restart sshd.service
exit
EOF

  [[ $? -ne 0 ]] && STEP_STATUS=0
}



function ssh_to_free_server() {

  start_spin "${yellow}${V[036]}${no_color}"
  run_step "step_ssh_to_free_server"
  if [[ "${STEP_STATUS}" -eq 0 ]]; then
    end_spin "${red}${V[010]} ${V[038]}${no_color} \n " && exit 1
  fi
  end_spin "${green}${V[037]}${no_color} \n "

}



function step_create_service_and_tunnel() {

sudo cat << EOF | sudo tee /etc/systemd/system/Qaysi@.service
[Unit]
Description=Reverse SSH Tunnel Port %I
After=network-online.target

[Service]
Type=simple
ExecStart=ssh -N -R 0.0.0.0:%i:localhost:%i root@$free_server_ip
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload

  for port in "${ports[@]}"
  do
  sudo systemctl start Qaysi@$port
  sudo systemctl enable Qaysi@$port
  done

  [[ $? -ne 0 ]] && STEP_STATUS=0
}



function create_service_and_tunnel() {

  start_spin "${yellow}${V[039]}${no_color}"
  run_step "step_create_service_and_tunnel"
  if [[ "${STEP_STATUS}" -eq 0 ]]; then
    end_spin "${red}${V[010]} ${V[041]}${no_color} \n " && exit 1
  fi
  end_spin "${green}${V[040]}${no_color}${green}${V[042]}${no_color} ${bYellow}${ports[@]}${no_color} \n "

}



function step_set_cronjob(){

  for port in "${ports[@]}"
  do
  echo "*/$cron_minutes * * * * systemctl restart Qaysi@$port" | (crontab -l; cat -) | crontab -
  done
  [[ $? -ne 0 ]] && STEP_STATUS=0

}



function set_cronjob(){

  start_spin "${yellow}${V[045]}${no_color}"
  run_step "step_set_cronjob"
  if [[ "${STEP_STATUS}" -eq 0 ]]; then
    end_spin "${red}${V[010]} ${V[047]}${no_color} \n " && exit 1
  fi
  end_spin "${green}${V[046]}${no_color} \n "

}





# ************* Run *************
clear
intro
check_root
install_base_packages
user_info
ssh_to_free_server
create_service_and_tunnel
set_cronjob

# END
clean_up
# END
