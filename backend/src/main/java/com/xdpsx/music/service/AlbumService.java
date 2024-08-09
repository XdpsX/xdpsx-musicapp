package com.xdpsx.music.service;

import com.xdpsx.music.dto.request.params.AlbumParams;
import com.xdpsx.music.dto.request.AlbumRequest;
import com.xdpsx.music.model.entity.Album;
import org.springframework.data.domain.Page;
import org.springframework.web.multipart.MultipartFile;

public interface AlbumService {
    Page<Album> getAllAlbums(AlbumParams params);
    Album getAlbumById(Long id);
    Album createAlbum(AlbumRequest request, MultipartFile image);
    Album updateAlbum(Long id, AlbumRequest request, MultipartFile image);
    void deleteAlbum(Long id);

    Page<Album> getAlbumsByGenreId(Integer genreId, AlbumParams params);
    Page<Album> getAlbumsByArtistId(Long artistId, AlbumParams params);
}
