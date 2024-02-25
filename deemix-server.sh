#!/bin/sh
test -d /deemix-gui/config || ( echo -- /deemix-gui/config is not present. This must be mounted via docker.; sleep 5; exit 1 )
echo -- Using user ID ${PUID}, group ID ${PGID}, umask ${UMASK} 
umask ${UMASK}
echo -- Effective ownership downloaded files will be ${PUID}:${PGID} $(umask -S)
chown -R ${PUID}:${PGID} /deemix-gui/config || (echo -- Unable to change ownership of /deemix-gui/config directory. Ensure it is mounted in Docker and has correct permissions. && exit )
exec /command/s6-setuidgid "$PUID:$PGID" /deemix-server --singleuser true --host 0.0.0.0
