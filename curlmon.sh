#!/usr/bin/env bash

RED="31m"
GREEN="32m"

# $1 text
# $2 color
function out(){
  echo -e "\e[$2$1\e[0m"
}

# $1 target
# $2 expectedCode
function checkResponseCode(){

  local responseCode=$(curl -L --write-out %{http_code} --silent --output /dev/null $1)

  if [[ "${responseCode}" == "$2" ]]; then
    printf '%-2s' "|" && out "READY" ${GREEN}
  else
    printf '%-2s' "|" && out "NOT READY" ${RED}
  fi
}

# $1 target
# $2 expectedRedirect
function checkRedirect(){

  local redirect=$(curl -i --silent $1 | grep "301 Moved Permanently" -A 1 | tail -n 1 | cut -d' ' -f2 | tr -d '[:space:]')

  if [[ "${redirect}" == "$2" ]]; then
    printf '%-2s' "|" && out "READY" ${GREEN}
  else
    printf '%-2s' "|" && out "NOT READY" ${RED}
  fi
}

function column1(){
  printf '%-20s' "| $1"
}

function column2(){
  printf '%-30s' "| $1"
}

column1 "SERVICE 1" && column2 www.google.com && checkResponseCode "www.google.com" 200
column1 "SERVICE 1x" && column2 www.google.com && checkRedirect "google.com" "http://www.google.com/"
column1 "SERVICE 2" && column2 www.google.com3 && checkResponseCode "www.google.comq3" 200

