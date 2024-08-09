package com.xdpsx.music.controller;

import com.xdpsx.music.dto.common.PageResponse;
import com.xdpsx.music.dto.request.TrackRequest;
import com.xdpsx.music.dto.request.params.TrackParams;
import com.xdpsx.music.dto.response.TrackResponse;
import com.xdpsx.music.mapper.PageMapper;
import com.xdpsx.music.mapper.TrackMapper;
import com.xdpsx.music.model.entity.Track;
import com.xdpsx.music.model.entity.User;
import com.xdpsx.music.security.UserContext;
import com.xdpsx.music.service.LikeService;
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
@RequestMapping("/tracks")
@RequiredArgsConstructor
public class TrackController {
    private final UserContext userContext;
    private final TrackService trackService;
    private final LikeService likeService;
    private final TrackMapper trackMapper;
    private final PageMapper pageMapper;

    @GetMapping
    public ResponseEntity<PageResponse<TrackResponse>> getAllTracks(
            @Valid TrackParams params
    ) {
        Page<Track> trackPage = trackService.getAllTracks(params);
        return ResponseEntity.ok(pageMapper.toPageResponse(trackPage, trackMapper::fromEntityToResponse));
    }

    @GetMapping("/{id}")
    public ResponseEntity<TrackResponse> getTrackById(@PathVariable Long id) {
        Track track = trackService.getTrackById(id);
        return ResponseEntity.ok(trackMapper.fromEntityToResponse(track));
    }

    @PostMapping
    public ResponseEntity<TrackResponse> createTrack(
            @Valid @ModelAttribute TrackRequest request,
            @RequestParam(required = false) MultipartFile image,
            @RequestParam MultipartFile file
    ) {
        Track createdTrack = trackService.createTrack(request, image, file);
        return new ResponseEntity<>(trackMapper.fromEntityToResponse(createdTrack), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<TrackResponse> updateTrack(
            @PathVariable Long id,
            @Valid @ModelAttribute TrackRequest request,
            @RequestParam(required = false) MultipartFile image,
            @RequestParam(required = false) MultipartFile file
    ) {
        Track updatedTrack = trackService.updateTrack(id, request, image, file);
        return ResponseEntity.ok(trackMapper.fromEntityToResponse(updatedTrack));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTrack(@PathVariable Long id) {
        trackService.deleteTrack(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @PostMapping("/{trackId}/likes")
    public ResponseEntity<?> likeTrack(@PathVariable Long trackId){
        User loggedUser = userContext.getLoggedUser();
        likeService.likeTrack(trackId, loggedUser);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("/{trackId}/unlikes")
    public ResponseEntity<?> unlikeTrack(@PathVariable Long trackId){
        User loggedUser = userContext.getLoggedUser();
        likeService.unlikeTrack(trackId, loggedUser);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/likes/contains")
    public ResponseEntity<List<Boolean>> checkLikesTrack(
            @RequestParam List<Long> trackIds) {
        User loggedUser = userContext.getLoggedUser();
        List<Boolean> responses = trackIds.stream()
                .map(trackId -> likeService.isTrackLikedByUser(trackId, loggedUser.getId()))
                .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }

    @PostMapping("/{trackId}/listen")
    public ResponseEntity<?> incrementListeningCount(@PathVariable Long trackId) {
        User loggedUser = userContext.getLoggedUser();
        trackService.incrementListeningCount(trackId, loggedUser);
        return ResponseEntity.ok().build();
    }
}
