#!/bin/bash
# Vorlage von https://github.com/vinayaugustine/backup.sh
read_config() {
    source ~/.restic/repo_config
}

backup() {
    read_config
    restic backup / --exclude-file $RESTIC_EXCLUDE_FILE
    restic forget --host $HOSTNAME --keep-daily 7 --keep-weekly 5 --keep-monthly 6
}

config() {
    read_config
    echo Config file:   ~/.restic/repo_config
    echo Password file: $RESTIC_PASSWORD_FILE
    echo Exclude file:  $RESTIC_EXCLUDE_FILE
    echo Repository:    $RESTIC_REPOSITORY
}

prune() {
    read_config
    restic prune
}

setup() {
    which restic
    if [ $? -ne 0 ]; then
        echo restic is not installed. See installation instructions at:
        echo http://restic.readthedocs.io/en/latest/020_installation.html
        exit 1
    fi

    mkdir -p ~/.restic

    RESTIC_REPOSITORY=/mnt/myCloud/restic.repo
    RESTIC_PASSWORD_FILE=~/.restic/passwd
    RESTIC_EXCLUDE_FILE=~/.restic/restic.excludes

    echo Saving repository config to ~/.restic/repo_config
    echo export RESTIC_REPOSITORY=$RESTIC_REPOSITORY > ~/.restic/repo_config
    echo export RESTIC_PASSWORD_FILE=$RESTIC_PASSWORD_FILE >> ~/.restic/repo_config
    echo export RESTIC_EXCLUDE_FILE=$RESTIC_EXCLUDE_FILE >> ~/.restic/repo_config

    echo "/mnt/*
    /proc/*
    /sys/*
    /dev/*
    /run/*
    /tmp/*
    /var/log/*" > ~/.restic/restic.excludes

    echo -n "Enter repository password: "
    read -s REPO_PASSWORD
    echo
    echo $REPO_PASSWORD > $RESTIC_PASSWORD_FILE

    read_config
    #restic check --no-lock

#    if [ $? -ne 0 ]; then
        # TODO need to read input for password
#        restic init
#    fi
}

help() {
    echo Wrapper script for backing up the home directory to B2 with restic
    echo -e '\t' $0 backup: Execute a backup with restic.
    echo -e '\t' $0 config: Print the restic repository.
    echo -e '\t' $0 prune:  Delete unneeded data to reduce repo size.
    echo -e '\t' $0 setup:  Setup restic for backup on my NAS.
}

if [[ $1 =~ ^(backup|config|prune|setup|help)$ ]]; then
  "$@"
else
  help
  exit 1
fi
