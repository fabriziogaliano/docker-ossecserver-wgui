#!/bin/env bash
# $Id: entrypoint.sh,v 0.1 2016/04/10 $ $Author: Pietro Bonaccorso $

if [ "$1" = "start-stack" ]; then

    #bootloading for configuration
    /bin/bash /docker/scripts/bootloader.sh

    #Boostrap Ossec
    /bin/bash /docker/scripts/ossec-bootstrap.sh
   
    #call supervisord to launch the whole stack
    /usr/bin/supervisord --nodaemon --configuration=/docker/configuration/supervisord/supervisor.conf

    # while :
    # do
    #     echo "Press [CTRL+C] to stop.."
    #     sleep 5
    # done

fi
