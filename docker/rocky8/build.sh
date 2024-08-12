#!/bin/bash

CONT_BIN="`which podman 2>/dev/null`"
if [ -z "$CONT_BIN" ]; then
   CONT_BIN="`which docker 2>/dev/null`"
fi
if [ -z "$CONT_BIN" ]; then
   echo "Missing podman or docker."
   exit 1
fi

"$CONT_BIN" build --tag rl8docker:latest .
"$CONT_BIN" run -ti --rm --name rl8docker -d rl8docker:latest
"$CONT_BIN" cp ../../ rl8docker:/nemea
"$CONT_BIN" exec -ti rl8docker bash -c 'cd /nemea; ./rpms.sh root'
"$CONT_BIN" exec -ti rl8docker bash -c 'cd /nemea; ls -l rpms'
"$CONT_BIN" cp rl8docker:/nemea/rpms rpms
"$CONT_BIN" cp rl8docker:/nemea/nemea-framework/pytrap/dist/ wheels/

# This will remove the container:
"$CONT_BIN" stop rl8docker

# This would remove the image:
# "$CONT_BIN" rmi rl8docker:latest

