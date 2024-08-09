package com.xdpsx.music.controller;

import com.xdpsx.music.dto.common.PageResponse;
import com.xdpsx.music.dto.request.params.AlbumParams;
import com.xdpsx.music.dto.request.AlbumRequest;
import com.xdpsx.music.dto.request.params.TrackParams;
import com.xdpsx.music.dto.response.AlbumResponse;
import com.xdpsx.music.dto.response.TrackResponse;
import com.xdpsx.music.mapper.AlbumMapper;
import com.xdpsx.music.mapper.PageMapper;
import com.xdpsx.music.model.entity.Album;
import com.xdpsx.music.service.AlbumService;
import com.xdpsx.music.service.TrackService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/albums")
@RequiredArgsConstructor
public class AlbumController {
    private final AlbumService albumService;
    private final TrackService trackService;
    private final AlbumMapper albumMapper;
    private final PageMapper pageMapper;

    @GetMapping
    public ResponseEntity<PageResponse<AlbumResponse>> getAllAlbums(
            @Valid AlbumParams params
    ) {
        Page<Album> albumPage = albumService.getAllAlbums(params);
        return ResponseEntity.ok(pageMapper.toPageResponse(albumPage, albumMapper::fromEntityToResponse));
    }

    @GetMapping("/{id}")
    public ResponseEntity<AlbumResponse> getAlbumById(@PathVariable Long id) {
        Album album = albumService.getAlbumById(id);
        return ResponseEntity.ok(albumMapper.fromEntityToResponse(album));
    }


    @PostMapping
    public ResponseEntity<AlbumResponse> createAlbum(
            @Valid @ModelAttribute AlbumRequest request,
            @RequestParam(required = false) MultipartFile image
    ) {
        Album createdAlbum = albumService.createAlbum(request, image);
        return new ResponseEntity<>(albumMapper.fromEntityToResponse(createdAlbum), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<AlbumResponse> updateAlbum(
            @PathVariable Long id,
            @Valid @ModelAttribute AlbumRequest request,
            @RequestParam(required = false) MultipartFile image
    ) {
        Album updatedAlbum = albumService.updateAlbum(id, request, image);
        return ResponseEntity.ok(albumMapper.fromEntityToResponse(updatedAlbum));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteAlbum(@PathVariable Long id) {
        albumService.deleteAlbum(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{albumId}/tracks")
    public ResponseEntity<PageResponse<TrackResponse>> getTracksByAlbum(
            @PathVariable Long albumId,
            @Valid TrackParams params
    ) {
        PageResponse<TrackResponse> response = trackService.getTracksByAlbumId(albumId, params);
        return ResponseEntity.ok(response);
    }
}
