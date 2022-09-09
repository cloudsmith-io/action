#!/bin/bash
self=$(readlink -f $BASH_SOURCE)

declare -A options

DEFAULT="none" # a way to handle ordered empty arguments of bash

function unset_api_key {
  unset CLOUDSMITH_API_KEY
}

trap "unset_api_key" EXIT

function warn {
  echo "Warning: $@" 1>&2
}


function die {
  echo "Error: $@" 1>&2
  exit 1
}


function setup_options {
  options["api_version"]=$DEFAULT
  options["cli_version"]=$DEFAULT
  options["api_key"]=$DEFAULT
  options["command"]="push"
  options["format"]=$DEFAULT
  options["owner"]=$DEFAULT
  options["repo"]=$DEFAULT
  options["file"]=$DEFAULT
  options["republish"]=$DEFAULT
  options["wait_interval"]=$DEFAULT
  options["no_wait_for_sync"]=$DEFAULT
  options["distro"]=$DEFAULT
  options["release"]=$DEFAULT
  options["name"]=$DEFAULT
  options["summary"]=$DEFAULT
  options["description"]=$DEFAULT
  options["version"]=$DEFAULT
  options["extra"]=$DEFAULT

  local raw_opts="$@"
  local OPTIND OPT

  while getopts ":a:c:C:k:K:f:o:r:F:P:w:W:d:R:n:s:S:V:" OPT; do
    case $OPT in
      a) options["api_version"]="$OPTARG" ;;
      c) options["cli_version"]="$OPTARG" ;;
      C) options["skip_install_cli"]="$OPTARG" ;;
      k) options["api_key"]="$OPTARG" ;;
      K) options["command"]="$OPTARG" ;;
      f) options["format"]="$OPTARG" ;;
      o) options["owner"]="$OPTARG" ;;
      r) options["repo"]="$OPTARG" ;;
      F) options["file"]="$OPTARG" ;;
      P) options["republish"]="$OPTARG" ;;
      w) options["wait_interval"]="$OPTARG" ;;
      W) options["no_wait_for_sync"]="$OPTARG" ;;
      d) options["distro"]="$OPTARG" ;;
      R) options["release"]="$OPTARG" ;;
      n) options["name"]="$OPTARG" ;;
      s) options["summary"]="$OPTARG" ;;
      S) options["description"]="$OPTARG" ;;
      V) options["version"]="$OPTARG" ;;
      :) die "Option -$OPTARG requires an argument." ;;
      ?)
        if [[ "$OPTARG" == *"-"* ]]; then
          break
        else
          die "Invalid option -$OPTARG."
        fi
      ;;
    esac
  done
  shift "$((OPTIND-1))"

  if [[ "$raw_opts" == *" -- "* ]]; then
    options["extra"]="${raw_opts##* -- }"
  fi
}


function check_option_set {
  # Check if a value is set and non-default
  local value="$@"
  test -n "$value" && test "$value" != "$DEFAULT"
  return $?
}


function check_option_true {
  # Check if a value is set and is true
  local value="$@"
  test "$value" == "true"
  return $?
}


function check_required_options {
  for option in $@
  do
    local value="${options[$option]}"
    if [[ -z "$value" || "$value" == "$DEFAULT" ]]; then
      die "$option is required, but not set (got: $value)!"
    fi
  done
}


function install_api_cli {
  if [[ "${options["skip_install_cli"]}" == "true" ]]; then
    warn "Skipping Cloudsmith API/CLI installation"
  else
    echo "Starting Cloudsmith API/CLI installation ..."

    check_option_set "${options["cli_version"]}" && {
      pip install cloudsmith-cli==${options["cli_version"]}
    } || {
      pip install cloudsmith-cli
    }

    check_option_set "${options["api_version"]}" && {
      pip install cloudsmith-api==${options["api_version"]}
    }
  fi
}


function execute_push {
  check_required_options format owner repo file

  local context="${options["owner"]}/${options["repo"]}"
  local params=""

  # Universal options
  check_option_true "${options["republish"]}" && {
    params+=" --republish"
  }
  check_option_set "${options["wait_interval"]}" && {
    params+=" --wait-interval='${options["wait_interval"]}'"
  }
  check_option_true "${options["no_wait_for_sync"]}" && {
    params+=" --no-wait-for-sync"
  }

  # Format specific options
  case "${options["format"]}" in
    "alpine"|"deb"|"rpm")
      check_required_options distro release
      context+="/${options["distro"]}/${options["release"]}"
    ;;

    "raw")
      check_option_set "${options["name"]}" && {
        params+=" --name='${options["name"]}'"
      }
      check_option_set "${options["summary"]}" && {
        params+=" --summary='${options["summary"]}'"
      }
      check_option_set "${options["description"]}" && {
        params+=" --description='${options["description"]}'"
      }
      check_option_set "${options["version"]}" && {
        params+=" --version='${options["version"]}'"
      }
    ;;

    "cargo"|"dart"|"docker"|"helm"|"python"|"composer"|"cocoapods")
      # Supported, but no additional options/params
    ;;

    *)
      warn "Format ${options["format"]} is not yet officially" \
        "supported within action (but might still work)."
    ;;
  esac

  check_option_set "${options["api_key"]}" && {
    export CLOUDSMITH_API_KEY="${options["api_key"]}"
  }

  local extra=""
  check_option_set "${options["extra"]}" && {
    extra="${options["extra"]}"
  }

  local request="cloudsmith push ${options["action"]} ${options["format"]} $context ${options["file"]} $params $extra"
  echo $request
  eval $request
}


function main {
  setup_options "$@"
  install_api_cli

  case "${options["command"]}" in
    "push")
      execute_push
    ;;

    *)
      die "Command ${options["command"]} is not supported!"
    ;;
  esac
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  main "$@"
fi
