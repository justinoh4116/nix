pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: root

    property MprisPlayer player: null
    property MprisPlayer lastPlayer: null
    property var players: new Set()

    function isSpotifyPlayer(player: MprisPlayer): bool {
        if (!player)
            return false;

        const desktopEntry = (player.desktopEntry || "").toLowerCase();
        const dbusName = (player.dbusName || "").toLowerCase();
        const identity = (player.identity || "").toLowerCase();

        return desktopEntry === "spotify"
            || dbusName === "org.mpris.mediaplayer2.spotify"
            || identity === "spotify";
    }

    function latestTrackedPlayer(): MprisPlayer {
        let latest = null;

        for (const trackedPlayer of players)
            latest = trackedPlayer;

        return latest;
    }

    function updatePlayer() {
        let leader = null;
        let backup = isSpotifyPlayer(lastPlayer) ? lastPlayer : latestTrackedPlayer();
        for (let player of Mpris.players.values) {
            if (!isSpotifyPlayer(player))
                continue;

            if (player.isPlaying) {
                backup = player;
                if (player.trackArtist !== "")
                    leader = player;
            }
        }

        player = isSpotifyPlayer(leader) ? leader : backup;
    }

    function handlePlayerChanged(player: MprisPlayer) {
        if (!isSpotifyPlayer(player)) {
            players.delete(player);

            if (lastPlayer === player)
                lastPlayer = latestTrackedPlayer();

            updatePlayer();
            return;
        }

        if (!player.isPlaying) {
            updatePlayer();
            return;
        }

        players.delete(player);
        players.add(player);
        lastPlayer = player ?? null;

        updatePlayer();
    }

    function playerDestroyed(player: MprisPlayer) {
        players.delete(player);
        lastPlayer = latestTrackedPlayer();

        updatePlayer();
    }

    Instantiator {
        model: Mpris.players

        Connections {
            required property MprisPlayer modelData
            target: modelData

            Component.onCompleted: root.handlePlayerChanged(modelData)
            Component.onDestruction: root.playerDestroyed(modelData)

            function onPlaybackStateChanged() {
                root.handlePlayerChanged(modelData);
            }
        }
    }

    IpcHandler {
        target: "mpris"

        function pauseAll() {
            for (const player of Mpris.players.values) {
                if (root.isSpotifyPlayer(player) && player.canPause)
                    player.pause();
            }
        }

        function togglePlaying() {
            const player = root.player;
            if (player && player.canTogglePlaying)
                player.togglePlaying();
        }

        function previous() {
            const player = root.player;
            if (player && player.canGoPrevious)
                player.previous();
        }

        function next() {
            const player = root.player;
            if (player && player.canGoNext)
                player.next();
        }
    }
}
