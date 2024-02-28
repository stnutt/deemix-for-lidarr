Extracted from https://github.com/youegraillot/lidarr-on-steroids/

Issues and Discussions are open, feel free to reach out.

Directly or indirectly using the work of these projects:
- https://gitlab.com/RemixDev/deemix-gui
- https://github.com/ta264/Lidarr.Plugin.Deemix
- https://ghcr.io/hotio/lidarr:pr-plugins

Links of note:
- https://github.com/youegraillot/lidarr-on-steroids/issues/92 (Origin, initial discussion)
- https://github.com/youegraillot/lidarr-on-steroids/issues/63 (Patch during docker build)

NOTES: 
- This expects a Lidarr branch which supports Plugins. I'm using Docker; ghcr.io/hotio/lidarr:pr-plugins
- My work here is solely rewriting https://github.com/youegraillot/lidarr-on-steroids/blob/main/Dockerfile and documenting things.
-- The Dockerfile downloads and builds https://gitlab.com/RemixDev/deemix-gui with a patch as suggested in https://github.com/youegraillot/lidarr-on-steroids/issues/63

[Docker-compose example](https://github.com/codefaux/deemix-for-lidarr/blob/main/docker-compose.yaml)
- You probably need to change PID/GID
- You must provide /deemix-gui/config via docker mountpoint or volume.

Quick setup info;
In Deemix:
- Go to Settings, check the boxes to "Create Folder Structure for" on Artists, Albums, and Singles
- Set the download folder where albums will be stored for import -- /downloads is typical, use same volume/path passed via Docker. Lidarr will also need this same volume/path.
-- The container places downloads into /deemix-gui/music by default, **change this** to the volume/path you provide (ie /downloads ) or it will bloat your image, downloads will not reach Lidarr, and downloads will disappear if you update the container.
- Log into Deezer

In Lidarr:
- Go into System / Plugins, and install this plugin via URL: https://github.com/ta264/Lidarr.Plugin.Deemix
- Go to Settings / Download Clients, add and configure a Deemix download client.
- It helps to use Docker's container name resolution feature for intra-container connections. Regardless of methodology, Docker will resolve a container name to its most accessible IP when referenced from inside a Docker environment. IE, name your containers "deemix" and "lidarr" and use "deemix:6595" instead of "\<ip\>:6595" when configuring both Download Client -and- Indexer. (Also useful for other containers, such as those requiring external database containers, regardless of wether or not they're in a docker-compose.yaml service group together.)
- Go to Settings / Indexers, add and configure a Deemix indexer.
-- You should disable RSS feeds, because Deemix doesn't support them.
- Under Settings / Profiles, look to Delay Profiles, and click the wrench on the right of the window for Default (or your custom profile(s)) and enable the Deemix protocol.

Despite appearances, I don't claim to fully know what I'm doing. Please submit an issue or PR if you think it makes sense. I don't anticipate changes unless issues are raised, but I don't intend to abandon it. I also can't/won't fix issues in upstream projects, as it's beyond my ken. If there's missing information, attribution, or other please let me know.
