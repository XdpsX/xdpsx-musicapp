package com.xdpsx.music.service;

import com.xdpsx.music.dto.common.PageResponse;
import com.xdpsx.music.dto.request.params.AlbumParams;
import com.xdpsx.music.dto.request.AlbumRequest;
import com.xdpsx.music.dto.response.AlbumResponse;
import org.springframework.web.multipart.MultipartFile;

public interface AlbumService {
    AlbumResponse createAlbum(AlbumRequest request, MultipartFile image);
    AlbumResponse updateAlbum(Long id, AlbumRequest request, MultipartFile image);
    AlbumResponse getAlbumById(Long id);
    PageResponse<AlbumResponse> getAllAlbums(AlbumParams params);
    void deleteAlbum(Long id);

    PageResponse<AlbumResponse> getAlbumsByGenreId(Integer genreId, AlbumParams params);
    PageResponse<AlbumResponse> getAlbumsByArtistId(Long artistId, AlbumParams params);
}
