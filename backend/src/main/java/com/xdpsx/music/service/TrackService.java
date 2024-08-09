package com.xdpsx.music.service;

import com.xdpsx.music.dto.request.TrackRequest;
import com.xdpsx.music.dto.request.params.TrackParams;
import com.xdpsx.music.model.entity.Track;
import com.xdpsx.music.model.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.web.multipart.MultipartFile;

public interface TrackService {
    Page<Track> getAllTracks(TrackParams params);
    Track getTrackById(Long id);
    Track createTrack(TrackRequest request, MultipartFile image, MultipartFile file);
    Track updateTrack(Long id, TrackRequest request, MultipartFile newImage, MultipartFile newFile);
    void deleteTrack(Long id);

    Page<Track> getTracksByGenreId(Integer genreId, TrackParams params);
    Page<Track> getTracksByArtistId(Long artistId, TrackParams params);
    Page<Track> getTracksByAlbumId(Long albumId, TrackParams params);
    Page<Track> getLikedTracks(TrackParams params, User loggedUser);
    Page<Track> getTracksByPlaylist(Long playlistId, TrackParams params);

    void incrementListeningCount(Long trackId, User loggedUser);
}
