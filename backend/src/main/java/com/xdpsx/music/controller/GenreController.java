package com.xdpsx.music.controller;

import com.xdpsx.music.dto.common.PageResponse;
import com.xdpsx.music.dto.request.params.AlbumParams;
import com.xdpsx.music.dto.request.GenreRequest;
import com.xdpsx.music.dto.request.params.TrackParams;
import com.xdpsx.music.dto.response.AlbumResponse;
import com.xdpsx.music.dto.response.GenreResponse;
import com.xdpsx.music.dto.response.TrackResponse;
import com.xdpsx.music.mapper.AlbumMapper;
import com.xdpsx.music.mapper.GenreMapper;
import com.xdpsx.music.mapper.PageMapper;
import com.xdpsx.music.model.entity.Album;
import com.xdpsx.music.model.entity.Genre;
import com.xdpsx.music.service.AlbumService;
import com.xdpsx.music.service.GenreService;
import com.xdpsx.music.service.TrackService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/genres")
@RequiredArgsConstructor
public class GenreController {
    private final GenreService genreService;
    private final AlbumService albumService;
    private final TrackService trackService;
    private final GenreMapper genreMapper;
    private final AlbumMapper albumMapper;
    private final PageMapper pageMapper;

    @PostMapping
    public ResponseEntity<GenreResponse> createGenre(
            @Valid @ModelAttribute GenreRequest request,
            @RequestParam MultipartFile image
            ){
        Genre createdGenre = genreService.createGenre(request, image);
        return new ResponseEntity<>(genreMapper.fromEntityToResponse(createdGenre), HttpStatus.CREATED);
    }

    @GetMapping
    public ResponseEntity<List<GenreResponse>> fetchAllGenres(){
        List<Genre> genres = genreService.getAllGenres();
        return ResponseEntity.ok(
                genres.stream()
                .map(genreMapper::fromEntityToResponse)
                .collect(Collectors.toList())
        );
    }

    @DeleteMapping("/{genreId}")
    public ResponseEntity<Void> deleteGenre(@PathVariable Integer genreId){
        genreService.deleteGenre(genreId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{genreId}/albums")
    public ResponseEntity<PageResponse<AlbumResponse>> getAlbumsByGenre(
            @PathVariable Integer genreId,
            @Valid AlbumParams params
    ){
        Page<Album> albumPage = albumService.getAlbumsByGenreId(genreId, params);
        return ResponseEntity.ok(pageMapper.toPageResponse(albumPage, albumMapper::fromEntityToResponse));
    }

    @GetMapping("/{genreId}/tracks")
    public ResponseEntity<PageResponse<TrackResponse>> getTracksByGenre(
            @PathVariable Integer genreId,
            @Valid TrackParams params
    ){
        PageResponse<TrackResponse> responses = trackService.getTracksByGenreId(genreId, params);
        return ResponseEntity.ok(responses);
    }
}
