package com.xdpsx.music.service.impl;

import com.xdpsx.music.exception.BadRequestException;
import com.xdpsx.music.model.entity.Playlist;
import com.xdpsx.music.model.entity.PlaylistTrack;
import com.xdpsx.music.model.entity.Track;
import com.xdpsx.music.model.entity.User;
import com.xdpsx.music.model.id.PlaylistTrackId;
import com.xdpsx.music.repository.PlaylistRepository;
import com.xdpsx.music.repository.PlaylistTrackRepository;
import com.xdpsx.music.security.UserContext;
import com.xdpsx.music.service.PlaylistService;
import com.xdpsx.music.service.PlaylistTrackService;
import com.xdpsx.music.service.TrackService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class PlaylistTrackServiceImpl implements PlaylistTrackService {
    private final UserContext userContext;
    private final PlaylistTrackRepository playlistTrackRepository;
    private final TrackService trackService;
    private final PlaylistRepository playlistRepository;
    private final PlaylistService playlistService;

    @Transactional
    @Override
    public void addTrackToPlaylist(Long playlistId, Long trackId) {
        Track track = trackService.getTrackById(trackId);
        User loggedUser = userContext.getLoggedUser();
        Playlist playlist = playlistService.getPlaylistByIdAndOwnerId(playlistId, loggedUser.getId());

        PlaylistTrackId id = new PlaylistTrackId(playlistId, trackId);
        if (playlistTrackRepository.existsById(id)) {
            throw new BadRequestException(
                    String.format("Track with id=%s is already in playlist", trackId)
            );
        }

        int trackNumber = playlistTrackRepository.countByPlaylistId(playlistId) + 1;
        PlaylistTrack playlistTrack = PlaylistTrack.builder()
                .id(id)
                .playlist(playlist)
                .track(track)
                .trackNumber(trackNumber)
                .build();
        playlistTrackRepository.save(playlistTrack);

        playlist.setUpdatedAt(LocalDateTime.now());
        playlistRepository.save(playlist);
    }

    @Override
    public void removeTrackFromPlaylist(Long playlistId, Long trackId) {
        Track track = trackService.getTrackById(trackId);
        User loggedUser = userContext.getLoggedUser();
        Playlist playlist = playlistService.getPlaylistByIdAndOwnerId(playlistId, loggedUser.getId());

        PlaylistTrackId id = new PlaylistTrackId(playlist.getId(), track.getId());
        if (!playlistTrackRepository.existsById(id)) {
            throw new BadRequestException(
                    String.format("Track with id=%s is not in playlist", trackId)
            );
        }

        playlistTrackRepository.deleteById(id);
    }

}
