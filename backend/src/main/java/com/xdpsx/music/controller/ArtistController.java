package com.xdpsx.music.controller;

import com.xdpsx.music.dto.request.params.AlbumParams;
import com.xdpsx.music.dto.request.params.ArtistParams;
import com.xdpsx.music.dto.request.ArtistRequest;
import com.xdpsx.music.dto.request.params.TrackParams;
import com.xdpsx.music.dto.response.AlbumResponse;
import com.xdpsx.music.dto.response.ArtistResponse;
import com.xdpsx.music.dto.common.PageResponse;
import com.xdpsx.music.dto.response.TrackResponse;
import com.xdpsx.music.mapper.AlbumMapper;
import com.xdpsx.music.mapper.ArtistMapper;
import com.xdpsx.music.mapper.PageMapper;
import com.xdpsx.music.model.entity.Album;
import com.xdpsx.music.model.entity.Artist;
import com.xdpsx.music.service.AlbumService;
import com.xdpsx.music.service.ArtistService;
import com.xdpsx.music.service.TrackService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/artists")
@RequiredArgsConstructor
public class ArtistController {
    private final ArtistService artistService;
    private final AlbumService albumService;
    private final TrackService trackService;
    private final ArtistMapper artistMapper;
    private final AlbumMapper albumMapper;
    private final PageMapper pageMapper;

    @GetMapping
    public ResponseEntity<PageResponse<ArtistResponse>> getAllArtists(
            @Valid ArtistParams params
    ) {
        Page<Artist> artistPage = artistService.getAllArtists(params);
        return ResponseEntity.ok(pageMapper.toPageResponse(artistPage, artistMapper::fromEntityToResponse));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ArtistResponse> getArtistById(@PathVariable Long id) {
        Artist artist = artistService.getArtistById(id);
        return ResponseEntity.ok(artistMapper.fromEntityToResponse(artist));
    }

    @PostMapping
    public ResponseEntity<ArtistResponse> createArtist(
            @Valid @ModelAttribute ArtistRequest request,
            @RequestParam(required = false) MultipartFile image
    ) {
        Artist createdArtist = artistService.createArtist(request, image);
        return new ResponseEntity<>(artistMapper.fromEntityToResponse(createdArtist), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ArtistResponse> updateArtist(
            @PathVariable Long id,
            @Valid @ModelAttribute ArtistRequest request,
            @RequestParam(required = false) MultipartFile image) {
        Artist updatedArtist = artistService.updateArtist(id, request, image);
        return ResponseEntity.ok(artistMapper.fromEntityToResponse(updatedArtist));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteArtist(@PathVariable Long id) {
        artistService.deleteArtist(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{artistId}/albums")
    public ResponseEntity<PageResponse<AlbumResponse>> getAlbumsByArtist(
            @PathVariable Long artistId,
            @Valid AlbumParams params
    ){
        Page<Album> albumPage = albumService.getAlbumsByArtistId(artistId, params);
        return ResponseEntity.ok(pageMapper.toPageResponse(albumPage, albumMapper::fromEntityToResponse));
    }

    @GetMapping("/{artistId}/tracks")
    public ResponseEntity<PageResponse<TrackResponse>> getTracksByArtist(
            @PathVariable Long artistId,
            @Valid TrackParams params
    ){
        PageResponse<TrackResponse> responses = trackService.getTracksByArtistId(artistId, params);
        return ResponseEntity.ok(responses);
    }
}
