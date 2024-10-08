package com.xdpsx.music.service;

import com.xdpsx.music.dto.common.PageResponse;
import com.xdpsx.music.dto.request.TrackRequest;
import com.xdpsx.music.dto.request.params.TrackParams;
import com.xdpsx.music.dto.response.TrackResponse;
import com.xdpsx.music.model.entity.User;
import org.springframework.web.multipart.MultipartFile;

public interface TrackService {
    TrackResponse createTrack(TrackRequest request, MultipartFile image, MultipartFile file);
    TrackResponse updateTrack(Long id, TrackRequest request, MultipartFile newImage, MultipartFile newFile);
    TrackResponse getTrackById(Long id);
    PageResponse<TrackResponse> getAllTracks(TrackParams params);
    void deleteTrack(Long id);

    PageResponse<TrackResponse> getTracksByGenreId(Integer genreId, TrackParams params);
    PageResponse<TrackResponse> getTracksByArtistId(Long artistId, TrackParams params);
    PageResponse<TrackResponse> getTracksByAlbumId(Long albumId, TrackParams params);
    PageResponse<TrackResponse> getLikedTracks(TrackParams params, User loggedUser);
    PageResponse<TrackResponse> getTracksByPlaylist(Long playlistId, TrackParams params);

    void incrementListeningCount(Long trackId, User loggedUser);
}
