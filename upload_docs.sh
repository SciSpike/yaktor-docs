#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script uploads the update site to a given subSite.

OPTIONS:
   -h                 Show this message
   -k [path]          to ssh -i pk
   -s <revision>      SubSite
EOF
}

SUB_SITE=
KEY=~/.ssh/inferwik_dsa

while getopts "hk:s:" OPTION
do
  case $OPTION in
    k)
      KEY=$OPTARG
      ;;
    s)
      SUB_SITE=$OPTARG
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done

if [[ -z $SUB_SITE ]]
then
  usage
  exit 1
fi
rsync -av --rsh="ssh -i ${KEY} -p 18765" documentation/build/docs/*  scispike@184.154.224.18:"public_html/conversation/docs_${SUB_SITE}"
