package com.xdpsx.music.service.impl;

import com.xdpsx.music.dto.request.params.AlbumParams;
import com.xdpsx.music.dto.request.AlbumRequest;
import com.xdpsx.music.model.entity.Album;
import com.xdpsx.music.model.entity.Artist;
import com.xdpsx.music.model.entity.Genre;
import com.xdpsx.music.exception.ResourceNotFoundException;
import com.xdpsx.music.mapper.AlbumMapper;
import com.xdpsx.music.repository.AlbumRepository;
import com.xdpsx.music.service.AlbumService;
import com.xdpsx.music.service.ArtistService;
import com.xdpsx.music.service.FileService;
import com.xdpsx.music.service.GenreService;
import com.xdpsx.music.util.Compare;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.stream.Collectors;

import static com.xdpsx.music.constant.FileConstants.ALBUMS_IMG_FOLDER;

@Service
@RequiredArgsConstructor
public class AlbumServiceImpl implements AlbumService {
    private final AlbumMapper albumMapper;
    private final FileService fileService;
    private final GenreService genreService;
    private final ArtistService artistService;
    private final AlbumRepository albumRepository;

    @Override
    public Page<Album> getAllAlbums(AlbumParams params) {
        Pageable pageable = PageRequest.of(params.getPageNum() - 1, params.getPageSize());
        return albumRepository.findWithFilters(
                pageable, params.getSearch(), params.getSort()
            );
    }

    @Override
    public Album getAlbumById(Long id) {
        Album album = fetchAlbumById(id);
        if (album == null){
            throw new ResourceNotFoundException(String.format("Not found album with ID=%s", id));
        }
        return album;
    }

    private Album fetchAlbumById(Long albumId) {
        return albumRepository.findById(albumId)
                .orElse(null);
    }

    @Override
    public Album createAlbum(AlbumRequest request, MultipartFile image) {
        Album album = albumMapper.fromRequestToEntity(request);

        // Image
        if (image != null){
            String imageUrl = fileService.uploadFile(image, ALBUMS_IMG_FOLDER);
            album.setImage(imageUrl);
        }

        // Genre
        Genre genre = genreService.getGenreById(request.getGenreId());
        album.setGenre(genre);

        // Artist
        List<Artist> artists = getArtistsByIds(request.getArtistIds());
        album.setArtists(artists);

        return albumRepository.save(album);
    }

    private List<Artist> getArtistsByIds(List<Long> artistIds) {
        return artistIds.stream()
                .map(artistService::getArtistById)
                .collect(Collectors.toList());
    }

    @Override
    public Album updateAlbum(Long id, AlbumRequest request, MultipartFile newImage) {
        Album album = getAlbumById(id);
        album.updateAlbum(request);

        // Image
        String oldImage = null;
        if (newImage != null){
            oldImage = album.getImage();
            String newImageUrl = fileService.uploadFile(newImage, ALBUMS_IMG_FOLDER);
            album.setImage(newImageUrl);
        }

        // Genre
        if (!album.getGenre().getId().equals(request.getGenreId())){
            Genre newGenre = genreService.getGenreById(request.getGenreId());
            album.setGenre(newGenre);
        }

        // Artist
        if (!Compare.isSameArtists(album.getArtists(), request.getArtistIds())){
            List<Artist> newArtists = getArtistsByIds(request.getArtistIds());
            album.setArtists(newArtists);
        }

        Album updatedAlbum = albumRepository.save(album);
        if (oldImage != null){
            fileService.deleteFileByUrl(oldImage);
        }
        return updatedAlbum;
    }

    @Override
    public void deleteAlbum(Long id) {
        Album album = getAlbumById(id);
        albumRepository.delete(album);
        fileService.deleteFileByUrl(album.getImage());
    }

    @Override
    public Page<Album> getAlbumsByGenreId(Integer genreId, AlbumParams params) {
        Genre genre = genreService.getGenreById(genreId);

        Pageable pageable = PageRequest.of(params.getPageNum() - 1, params.getPageSize());
        return albumRepository.findAlbumsByGenre(
                pageable, params.getSearch(), params.getSort(), genre.getId()
            );
    }

    @Override
    public Page<Album> getAlbumsByArtistId(Long artistId, AlbumParams params) {
        Artist artist = artistService.getArtistById(artistId);
        Pageable pageable = PageRequest.of(params.getPageNum() - 1, params.getPageSize());
        return albumRepository.findAlbumsByArtist(
                pageable, params.getSearch(), params.getSort(), artist.getId()
            );
    }

}
