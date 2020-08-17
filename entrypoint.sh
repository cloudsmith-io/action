#!/bin/bash

set -e #exit on error

DEFAULT="none" # a way to handle ordered empty arguments of bash

api_key=${1}
command=${2}
format=${3}
owner=${4}
repo=${5}
file=${6}
distro=${7}
release=${8}
version=${9}
name=${10}
summary=${11}
description=${12}
republish=${13}

# requires a CLOUDSMITH_API_KEY env variable to push
if [[ -z $api_key || $api_key == $DEFAULT ]]; then
    echo "CLOUDSMITH_API_KEY is required"
    exit 1
fi

if [[ -z $command || $command == $DEFAULT ]]; then
    echo "command is required"
    exit 1
fi
if [[ -z $format || $format == $DEFAULT ]]; then
    echo "format is required"
    exit 1
fi
if [[ -z $owner || $owner == $DEFAULT ]]; then
    echo "owner is required"
    exit 1
fi
if [[ -z $repo || $repo == $DEFAULT ]]; then
    echo "repo is required"
    exit 1
fi
if [[ -z "$file" || $file == $DEFAULT   ]]; then
    echo "file is required."
    exit 3
fi

if [[ "$command" != "push" ]]; then
    echo "command $command not yet implemented."
    exit 3
fi



case "$format" in
  "alpine"|"dart"|"deb"|"docker"|"raw")
    
    if [[ -n "$distro" && "$distro" != $DEFAULT ]]; then
        distro_path="/$distro"
        if [[ -n "$release" && $release != $DEFAULT ]]; then
            distro_path="$distro_path/$release"
        fi
    fi

    # these optional args provided only if valid
    # notice the spaces are built into the args
    if [[ -n "$version" && "$version" != $DEFAULT ]]; then
        version_arg=" --version=\"$version\""
    fi
    if [[ -n "$name" && "$name" != "$DEFAULT" ]]; then
        name_arg=" --name=\"$name\""
    fi
    if [[ -n "$summary" && "$summary" != $DEFAULT ]]; then
        summary_arg=" --summary=\"$summary\""
    fi
    if [[ -n "$description" && "$description" != $DEFAULT ]]; then
        description_arg=" --description=\"$description\""
    fi
    if [[ "$republish" == "true" || $republish == true ]]; then
        republish_arg=" --republish"
    fi
  ;;
  *)
    echo "format $format not yet officially supported within action."
  ;;
esac

export CLOUDSMITH_API_KEY=$api_key

pip install cloudsmith-cli

request="cloudsmith push $action $format $owner/$repo$distro_path$version_arg$name_arg$summary_arg$description_arg$republish_arg $file"

echo $request

eval $request
