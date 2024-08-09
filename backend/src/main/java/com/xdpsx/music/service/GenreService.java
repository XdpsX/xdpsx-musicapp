package com.xdpsx.music.service;

import com.xdpsx.music.dto.request.GenreRequest;
import com.xdpsx.music.model.entity.Genre;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface GenreService {
    Genre createGenre(GenreRequest request, MultipartFile image);
    List<Genre> getAllGenres();
    void deleteGenre(Integer genreId);
}
