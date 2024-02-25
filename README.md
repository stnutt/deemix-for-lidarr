
Extracted from https://github.com/youegraillot/lidarr-on-steroids/

See https://github.com/youegraillot/lidarr-on-steroids/issues/92

NOTES: 

Quick info;
In Deemix:
- Go to Settings, check the boxes to "Create Folder Structure for" on Artists, Albums, and Singles
- Log into Deezer
- Set the download folder where albums will be stored for import

In Lidarr:
- Go into System / Plugins, and paste this URL into the plugins section:
https://github.com/ta264/Lidarr.Plugin.Deemix

- Once the plugin is added, go to Settings / Download Client and add a Deemix client.
- Go to Settings / Indexers, and add a Deemix indexer.
-- You should disable RSS feeds, because Deemix doesn't support them.
- Under Settings / Profiles, Delay Profiles, click the wrench by Default (or your custom profile(s)) and enable Deemix

- Container places downloads into /deemix-gui/music by default, change this to the volume you provide (ie /downloads )

