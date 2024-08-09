package com.xdpsx.music.service;

import com.xdpsx.music.dto.request.params.ArtistParams;
import com.xdpsx.music.dto.request.ArtistRequest;
import com.xdpsx.music.model.entity.Artist;
import org.springframework.data.domain.Page;
import org.springframework.web.multipart.MultipartFile;

public interface ArtistService {
    Page<Artist> getAllArtists(ArtistParams params);
    Artist getArtistById(Long id);
    Artist createArtist(ArtistRequest request, MultipartFile image);
    Artist updateArtist(Long id, ArtistRequest request, MultipartFile image);
    void deleteArtist(Long id);
}
