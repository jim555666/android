#!/bin/bash

# wget jdk1.8.0-8u191
usage()
{
  echo "Usage $0 [-c <country>] [-u <domain>] [-d <id>] [-p <port>] [-i <to_ip>] [-t <to_port>] [-o <console_host>] [-s <sure_reboot>] [-f <free_node>] [-x cert_commonName_ip]"
  echo "    Options:"
  echo "    -c if china,please enter params"
  echo "    -u remoteDomain"
  echo "    -d remoteIp"
  echo "    -p remotePort"
  echo "    -i relayNodeIP or relayNodeDomain"
  echo "    -t relayPort"
  echo "    -o console_host,default "  
  echo "    -s sure allow reboot at successed"
  echo "    -f currentNode is_free 0/1"
  echo "    -x cert server commonName(NativeIp)"
  echo "    -h help"
  exit 1 
}

PWDS=`pwd`

ustar()
{
  if [ -d ${PWDS}/server ];
    then
      rm -rf ${PWDS}/server
      tar -zxvf server.tar.gz
    else
      tar -zxvf server.tar.gz
    fi
}
move_jdk()
{
  if [ -f jdk-8u251-linux-x64.tar.gz ];
  then
    mv jdk-8u251-linux-x64.tar.gz ${PWDS}/server/myscript
  fi
  cd ${PWDS}/server/myscript
}

if [[ $1 ]];
then
  res=$(echo $1 | grep "-")
  if [[ ${res} != "" ]];
  then
    while getopts "c:d:u:p:i:t:o:s:f:x:h" arg
    do
      case $arg in
        c)
          country=$OPTARG
          ;;
        d)
          remoteIP=$OPTARG
          ;;
        u)
          redomain=$OPTARG
          ;;
        p)
          remotePort=$OPTARG
          ;;
        i)
          relayIP=$OPTARG
          ;;
        t)
          relayPort=$OPTARG
          ;;
        o)
          console_host=$OPTARG
          ;;
        s)
          sure_reboot=$OPTARG
          ;;
        f)
          is_free=$OPTARG
          ;;
        x)
          commonName=$OPTARG
          ;;
        h)
          usage
          exit 0
          ;;
        ?)
          usage
          exit 1
          ;;
      esac
    done
    if [[ ${country} ]];
    then
      C="-c ${country}"
    fi

    if [[ ${remoteIP} ]];
    then
      D=" -d ${remoteIP}"
    fi
    if [[ ${redomain} ]];
    then 
      U=" -u ${redomain}"
    fi

    if [[ ${remotePort} ]];
    then
      P=" -p ${remotePort}"
    fi

    if [[ ${relayIP} ]];
    then
      R=" -r ${relayIP}"
    fi

    if [[ ${relayPort} ]];
    then
      B=" -b ${relayPort}"
    fi
    if [[ ${console_host} ]];
    then
      S="-s ${console_host}"
    else
      S="-s www.baidu.com" ## default console_host
    fi
    if [[ ${sure_reboot} ]];
    then
      Q="-q ${sure_reboot}"
    fi
    if [[ ${is_free} ]];
    then
      F="-f ${is_free}"
    fi
    if [[ $commonName ]];
    then
      X="-x ${commonName}"
    fi

    ustar
    move_jdk
    echo "here" $C $D $P $R $B $S $Q $F $X
    bash server_conf.sh $C $D $U $P $R $B $S $Q $F $X

  else
    usage
  fi

else
  ustar
  move_jdk
  bash server_conf.sh
fi

