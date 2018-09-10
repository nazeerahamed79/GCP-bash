#!/bin/bash
#
# Copyright (c)
# All rights reserved.
#
# Original: username <username@gmail.com>, Aug 2018


TOOLS_VERSION="1.0"

myname=$(basename $0)
mydir=$(dirname $0)
#echo $mydir
bindir=$mydir
contact='nazeer@hotmail.com'
usage() {
    printf %s "\
usage: $myname [-h] [command] [arguments]
positional arguments:
  command               command name to run
optional arguments:
  -h, --help            show this help message and exit
"
echo "$myname [command] arguments"
. ${bindir}/configure-instance-help.sh
    exit 0
}

if [[ $# -lt 1 ]]; then
    usage
fi

while [[ $# -ge 1 ]]
do
  key="$1"
  #echo $key
  if [[ $key =~ ^(help|--help|-h|-help)$ ]]; then
    usage
  elif [[ $key =~ ^(upgradeos|install|change_ntp|change_nameserver|delete_backup|backup|change_ntp|set_default_html|change_nameserver|mount_filesystem|change_hostname|change_dns)$ ]]; then
    COMMAND=$key
  elif [[ $key =~ ^(-v|--version)$ ]]; then
    echo "${TOOLS_VERSION}"
    exit 0
  else
    echo "INFO: Command not found, kindly check help"
    exit 0
  fi
  shift
  while [[ $# -ge 1 ]]
  do
    sub_key=$1
    case $sub_key in
        -d|--d|-disk|--disk)
        DISK="$2"
        shift # past argument
        ;;
        -i|--i|-instance|--instance)
        INSTANCE="$2"
        shift # past argument
        ;;
        help|--help|-h|-help)
        usage
        ;;
    esac
    shift # past argument or value
  done
  shift
done

#Varaiable declaration
CURRENT_USER=$(whoami)

function validate_disk_input(){
  if [[ -z ${DISK} ]]; then
      echo "Diskname is mandatory input"
      exit 0
  fi
}


#function change_ntp(){
#}

#function change_nameserver(){
#}


function validate_instance_input(){
  if [[ -z ${INSTANCE} ]]; then
      echo "Instance name is mandatory input"
      exit 0
  fi
}

function change_hostname(){
   validate_instance_input	
   #Assign existing hostname to $hostn
   hostn=`hostname`

   #Display existing hostname
   echo "Existing hostname is $hostn"
   echo "Changing hostname to $INSTANCE"
   sudo cp /etc/hosts /etc/hosts.bck 
   if [ $? -ne 0 ]; then
      echo "Error: copying /etc/hosts to /etc/hosts.bck"
      exit 1
   fi 	   
   #change hostname in /etc/hosts & /etc/hostname
   sudo sed -i "s/$hostn/$INSTANCE/g" /etc/hosts
   if [ $? -ne 0 ]; then
      echo "Error: Changing hostname on file /etc/hosts"
      exit 1
   fi 	   
   #display new hostname
   echo "Your new hostname is $INSTANCE"
}



function print_inputs() {
  echo "Command:$COMMAND"
}

function execute_commands()
{
  if [[ $COMMAND == "upgradeos" ]];then
     upgradeos 
  elif [[ $COMMAND == "mount" ]];then
     mount_filesystem
  elif [[ $COMMAND == "install" ]];then
     install
  elif [[ $COMMAND == "change_hostname" ]];then
     change_hostname 
  elif [[ $COMMAND == "change_ntp" ]];then
     change_ntp
  elif [[ $COMMAND == "change_nameserver" ]];then
     change_nameserver
  elif [[ $COMMAND == "set_default_html" ]];then
     set_default_html
  elif [[ $COMMAND == "backup" ]];then
     backup     
  elif [[ $COMMAND == "delete_backup" ]];then
     delete_backup 
  else
    echo "Error:Command:${COMMAND} not found"
    exit 1
  fi
}

function upgradeos(){
   echo "-------------upgrading os--------"
   sudo apt-get upgrade
}

function install(){
    echo "--------installing git, nginx-------"
    sudo apt-get install -y git nginx
    if [[ $? -ne 0 ]]; then
      echo "Error: Installing git and nginx"
      exit 1
    fi
}

#delete backup after 1 week

function delete_backup(){
   echo "--------Delete backup-------"
   find /mnt/data/backups/*.nginx -mtime +7 type f -delete
   if [[ $? -ne 0 ]]; then
       echo "Error: Deleting back up"
       exit 1
   fi
}



#Main function
print_inputs
execute_commands
