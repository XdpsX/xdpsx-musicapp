package com.xdpsx.music.service.impl;

import com.xdpsx.music.dto.request.TrackRequest;
import com.xdpsx.music.dto.request.params.TrackParams;
import com.xdpsx.music.model.entity.*;
import com.xdpsx.music.exception.ResourceNotFoundException;
import com.xdpsx.music.mapper.TrackMapper;
import com.xdpsx.music.repository.*;
import com.xdpsx.music.security.UserContext;
import com.xdpsx.music.service.*;
import com.xdpsx.music.util.Compare;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.stream.Collectors;

import static com.xdpsx.music.constant.FileConstants.*;

@Service
@RequiredArgsConstructor
public class TrackServiceImpl implements TrackService {
    private final TrackMapper trackMapper;
    private final FileService fileService;
    private final AlbumService albumService;
    private final GenreService genreService;
    private final ArtistService artistService;
    private final TrackRepository trackRepository;
    private final PlaylistRepository playlistRepository;
    private final UserContext userContext;

    @Override
    public Page<Track> getAllTracks(TrackParams params) {
        Pageable pageable = PageRequest.of(params.getPageNum() - 1, params.getPageSize());
        return trackRepository.findWithFilters(
                pageable, params.getSearch(), params.getSort()
            );
    }

    @Override
    public Track getTrackById(Long id) {
        Track track = fetchTrackById(id);
        if (track == null){
            throw new ResourceNotFoundException(String.format("Not found track with ID=%s", id));
        }
        return track;
    }

    private Track fetchTrackById(Long trackId) {
        return trackRepository.findById(trackId)
                .orElse(null);
    }

    @Override
    public Track createTrack(TrackRequest request, MultipartFile image, MultipartFile file) {
        Track track = trackMapper.fromRequestToEntity(request);

        // Track could belong to an Album or not
        Album album = getAlbumIfExists(request.getAlbumId());
        if (album != null) {
            setTrackNumber(track, album);
        }
        // Get Genre and Artists
        Genre genre = genreService.getGenreById(request.getGenreId());
        List<Artist> artists = getArtists(request.getArtistIds());

        track.setAlbum(album);
        track.setGenre(genre);
        track.setArtists(artists);

        // Image and File
        track.setImage(uploadFile(image, TRACKS_IMG_FOLDER));
        track.setUrl(uploadFile(file, TRACKS_FILE_FOLDER));

        return trackRepository.save(track);
    }

    private Album getAlbumIfExists(Long albumId) {
        return albumId == null ? null : albumService.getAlbumById(albumId);
    }

    private void setTrackNumber(Track track, Album album) {
        int count = trackRepository.countByAlbumId(album.getId());
        track.setTrackNumber(count+1);
    }

    private List<Artist> getArtists(List<Long> artistIds) {
        return artistIds.stream()
                .map(artistService::getArtistById)
                .collect(Collectors.toList());
    }

    private String uploadFile(MultipartFile file, String folder) {
        return file != null ? fileService.uploadFile(file, folder) : null;
    }

    @Transactional
    @Override
    public Track updateTrack(Long id, TrackRequest request, MultipartFile newImage, MultipartFile newFile) {
        Track trackToUpdate = getTrackById(id);
        updateTrackDetails(trackToUpdate, request, newImage, newFile);

        Track updatedTrack = trackRepository.save(trackToUpdate);
        deleteOldFiles(trackToUpdate, newImage, newFile);

        return updatedTrack;
    }

    private void updateTrackDetails(Track trackToUpdate, TrackRequest request,
                                    MultipartFile newImage, MultipartFile newFile) {
        trackToUpdate.setName(request.getName());

        if (isAlbumUpdateNeeded(trackToUpdate, request.getAlbumId())) {
            handleAlbumUpdate(trackToUpdate, request.getAlbumId());
        }

        if (!trackToUpdate.getGenre().getId().equals(request.getGenreId())) {
            trackToUpdate.setGenre(genreService.getGenreById(request.getGenreId()));
        }

        if (!Compare.isSameArtists(trackToUpdate.getArtists(), request.getArtistIds())) {
            trackToUpdate.setArtists(getArtists(request.getArtistIds()));
        }

        if (newImage != null) {
            trackToUpdate.setImage(uploadFile(newImage, TRACKS_IMG_FOLDER));
        }

        if (newFile != null) {
            trackToUpdate.setUrl(uploadFile(newFile, TRACKS_FILE_FOLDER));
            trackToUpdate.setDurationMs(request.getDurationMs());
        }
    }

    private boolean isAlbumUpdateNeeded(Track trackToUpdate, Long albumId) {
        return (trackToUpdate.getAlbum() == null) ? (albumId != null) : !trackToUpdate.getAlbum().getId().equals(albumId);
    }

    private void handleAlbumUpdate(Track trackToUpdate, Long newAlbumId) {
        if (newAlbumId != null) {
            Album newAlbum = albumService.getAlbumById(newAlbumId);
            int newTrackNumber = trackRepository.countByAlbumId(newAlbum.getId());
            trackToUpdate.setTrackNumber(newTrackNumber + 1);
            trackToUpdate.setAlbum(newAlbum);
        } else {
            trackToUpdate.setTrackNumber(null);
            trackToUpdate.setAlbum(null);
        }
    }

    private void deleteOldFiles(Track trackToUpdate, MultipartFile newImage, MultipartFile newFile) {
        if (newImage != null) {
            fileService.deleteFileByUrl(trackToUpdate.getImage());
        }
        if (newFile != null) {
            fileService.deleteFileByUrl(trackToUpdate.getUrl());
        }
    }

    @Transactional
    @Override
    public void deleteTrack(Long id) {
        Track trackToDelete = getTrackById(id);
        trackRepository.delete(trackToDelete);
        deleteFiles(trackToDelete);
    }

    private void deleteFiles(Track track) {
        fileService.deleteFileByUrl(track.getImage());
        fileService.deleteFileByUrl(track.getUrl());
    }

    @Override
    public Page<Track> getTracksByGenreId(Integer genreId, TrackParams params) {
        Genre genre = genreService.getGenreById(genreId);
        Pageable pageable = PageRequest.of(params.getPageNum() - 1, params.getPageSize());
        return trackRepository.findTracksByGenre(
                pageable, params.getSearch(), params.getSort(), genre.getId()
            );
    }

    @Override
    public Page<Track> getTracksByArtistId(Long artistId, TrackParams params) {
        Artist artist = artistService.getArtistById(artistId);
        Pageable pageable = PageRequest.of(params.getPageNum() - 1, params.getPageSize());
        return trackRepository.findTracksByArtist(
                pageable, params.getSearch(), params.getSort(), artist.getId()
            );
    }

    @Override
    public Page<Track> getTracksByAlbumId(Long albumId, TrackParams params) {
        Album album = albumService.getAlbumById(albumId);
        Pageable pageable = PageRequest.of(params.getPageNum() - 1, params.getPageSize());
        return trackRepository.findTracksByAlbum(
                pageable, params.getSearch(), params.getSort(), album.getId()
            );
    }

    @Override
    public Page<Track> getLikedTracks(TrackParams params, User loggedUser) {
        Pageable pageable = PageRequest.of(params.getPageNum() - 1, params.getPageSize());
        return trackRepository.findFavoriteTracksByUserId(
                pageable, params.getSearch(), params.getSort(), loggedUser.getId()
        );
    }

    @Override
    public Page<Track> getTracksByPlaylist(Long playlistId, TrackParams params) {
        User loggedUser = userContext.getLoggedUser();
        playlistRepository.findByIdAndOwnerId(playlistId, loggedUser.getId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        String.format("Playlist with id=%s not found", playlistId)
                ));

        Pageable pageable = PageRequest.of(params.getPageNum() - 1, params.getPageSize());
        return trackRepository.findTracksInPlaylist(
                pageable, params.getSearch(), params.getSort(), playlistId
            );
    }

    @Override
    public void incrementListeningCount(Long trackId, User loggedUser) {
        Track track = getTrackById(trackId);
        track.setListeningCount(track.getListeningCount() + 1);
        trackRepository.save(track);
    }

}
