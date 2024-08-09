package com.xdpsx.music.service;

import com.xdpsx.music.dto.request.GenreRequest;
import com.xdpsx.music.model.entity.Genre;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface GenreService {
    List<Genre> getAllGenres();
    Genre getGenreById(Integer id);
    Genre createGenre(GenreRequest request, MultipartFile image);
    void deleteGenre(Integer genreId);
}
