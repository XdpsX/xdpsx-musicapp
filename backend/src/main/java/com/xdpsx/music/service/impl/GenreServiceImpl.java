package com.xdpsx.music.service.impl;

import com.xdpsx.music.dto.request.GenreRequest;
import com.xdpsx.music.model.entity.Genre;
import com.xdpsx.music.exception.BadRequestException;
import com.xdpsx.music.exception.ResourceNotFoundException;
import com.xdpsx.music.mapper.GenreMapper;
import com.xdpsx.music.repository.GenreRepository;
import com.xdpsx.music.service.FileService;
import com.xdpsx.music.service.GenreService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

import static com.xdpsx.music.constant.FileConstants.GENRES_IMG_FOLDER;

@Service
@RequiredArgsConstructor
public class GenreServiceImpl implements GenreService {
    private final GenreMapper genreMapper;
    private final FileService fileService;
    private final GenreRepository genreRepository;

    @Override
    public List<Genre> getAllGenres() {
        return genreRepository.findAll();
    }

    @Override
    public Genre getGenreById(Integer id) {
        Genre genre = fetchGenreById(id);
        if (genre == null){
            throw new ResourceNotFoundException(String.format("Not found genre with ID=%s", id));
        }
        return genre;
    }

    private Genre fetchGenreById(Integer genreId){
        return genreRepository.findById(genreId)
                .orElse(null);
    }
    @Override
    public Genre createGenre(GenreRequest request, MultipartFile image) {
            if (genreRepository.existsByName(request.getName())){
                throw new BadRequestException(String.format("Genre with name=%s has already existed", request.getName()));
            }
            Genre genre = genreMapper.fromRequestToEntity(request);
            String imageUrl = fileService.uploadFile(image, GENRES_IMG_FOLDER);
            genre.setImage(imageUrl);
            return genreRepository.save(genre);
    }

    @Override
    public void deleteGenre(Integer genreId) {
        Genre genre = genreRepository.findById(genreId)
                .orElseThrow(() -> new ResourceNotFoundException(String.format("Not found genre with ID=%s", genreId)));
        genreRepository.delete(genre);
        fileService.deleteFileByUrl(genre.getImage());
    }
}
