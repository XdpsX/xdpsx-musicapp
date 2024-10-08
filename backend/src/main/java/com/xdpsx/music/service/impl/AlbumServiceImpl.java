package com.xdpsx.music.service.impl;

import com.xdpsx.music.constant.Keys;
import com.xdpsx.music.dto.common.PageResponse;
import com.xdpsx.music.dto.request.params.AlbumParams;
import com.xdpsx.music.dto.request.AlbumRequest;
import com.xdpsx.music.dto.response.AlbumResponse;
import com.xdpsx.music.mapper.PageMapper;
import com.xdpsx.music.model.entity.Album;
import com.xdpsx.music.model.entity.Artist;
import com.xdpsx.music.model.entity.Genre;
import com.xdpsx.music.exception.ResourceNotFoundException;
import com.xdpsx.music.mapper.AlbumMapper;
import com.xdpsx.music.repository.AlbumRepository;
import com.xdpsx.music.repository.ArtistRepository;
import com.xdpsx.music.repository.GenreRepository;
import com.xdpsx.music.service.AlbumService;
import com.xdpsx.music.service.FileService;
import com.xdpsx.music.util.Compare;
import com.xdpsx.music.util.I18nUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
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
    private final PageMapper pageMapper;
    private final FileService fileService;
    private final AlbumRepository albumRepository;
    private final GenreRepository genreRepository;
    private final ArtistRepository artistRepository;
    private final I18nUtils i18nUtils;

    @CachePut(value = Keys.ALBUM_ITEM, key = "#result.id")
    @Caching(evict = {
            @CacheEvict(cacheNames = Keys.ALBUMS, allEntries = true),
            @CacheEvict(cacheNames = Keys.GENRE_ALBUMS, allEntries = true),
            @CacheEvict(cacheNames = Keys.ARTIST_ALBUMS, allEntries = true)
    })
    @Override
    public AlbumResponse createAlbum(AlbumRequest request, MultipartFile image) {
        Album album = albumMapper.fromRequestToEntity(request);

        // Image
        if (image != null){
            String imageUrl = fileService.uploadFile(image, ALBUMS_IMG_FOLDER);
            album.setImage(imageUrl);
        }

        // Genre
        Genre genre = fetchGenreById(request.getGenreId());
        album.setGenre(genre);

        // Artist
        List<Artist> artists = getArtistsByIds(request.getArtistIds());
        album.setArtists(artists);

        Album savedAlbum = albumRepository.save(album);
        return albumMapper.fromEntityToResponse(savedAlbum);
    }

    @CachePut(value = Keys.ALBUM_ITEM, key = "#result.id")
    @Caching(evict = {
            @CacheEvict(cacheNames = Keys.ALBUMS, allEntries = true),
            @CacheEvict(cacheNames = Keys.GENRE_ALBUMS, allEntries = true),
            @CacheEvict(cacheNames = Keys.ARTIST_ALBUMS, allEntries = true)
    })
    @Override
    public AlbumResponse updateAlbum(Long id, AlbumRequest request, MultipartFile newImage) {
        Album album = fetchAlbumById(id);
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
            Genre newGenre = fetchGenreById(request.getGenreId());
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
        return albumMapper.fromEntityToResponse(updatedAlbum);
    }

    @Cacheable(value = Keys.ALBUM_ITEM, key = "#id")
    @Override
    public AlbumResponse getAlbumById(Long id) {
        Album album = fetchAlbumById(id);
        return albumMapper.fromEntityToResponse(album);
    }

    @Cacheable(cacheNames = Keys.ALBUMS, key = "#params")
    @Override
    public PageResponse<AlbumResponse> getAllAlbums(AlbumParams params) {
        Pageable pageable = PageRequest.of(params.getPageNum() - 1, params.getPageSize());
        Page<Album> albumPage = albumRepository.findWithFilters(
                pageable, params.getSearch(), params.getSort()
        );
        return pageMapper.toAlbumPageResponse(albumPage);
    }


    @Override
    @Caching(evict = {
            @CacheEvict(value = Keys.ALBUM_ITEM, key = "#id"),
            @CacheEvict(value = Keys.ALBUMS, allEntries = true),
            @CacheEvict(cacheNames = Keys.GENRE_ALBUMS, allEntries = true),
            @CacheEvict(cacheNames = Keys.ARTIST_ALBUMS, allEntries = true)
    })
    public void deleteAlbum(Long id) {
        Album album = fetchAlbumById(id);
        fileService.deleteFileByUrl(album.getImage());
        albumRepository.delete(album);
    }

    @Cacheable(cacheNames = Keys.GENRE_ALBUMS,
            key = "#genreId + '_' + #params")
    @Override
    public PageResponse<AlbumResponse> getAlbumsByGenreId(Integer genreId, AlbumParams params) {
        Genre genre = fetchGenreById(genreId);

        Pageable pageable = PageRequest.of(params.getPageNum() - 1, params.getPageSize());
        Page<Album> albumPage = albumRepository.findAlbumsByGenre(
                pageable, params.getSearch(), params.getSort(), genre.getId()
        );
        return pageMapper.toAlbumPageResponse(albumPage);
    }

    private Genre fetchGenreById(Integer genreId) {
        return genreRepository.findById(genreId)
                .orElseThrow(() -> new ResourceNotFoundException(i18nUtils.getGenreNotFoundMsg(genreId)));
    }

    @Override
    @Cacheable(cacheNames = Keys.ARTIST_ALBUMS, key = "#artistId + '_' + #params")
    public PageResponse<AlbumResponse> getAlbumsByArtistId(Long artistId, AlbumParams params) {
        Artist artist = artistRepository.findById(artistId)
                .orElseThrow(() -> new ResourceNotFoundException(i18nUtils.getArtistNotFoundMsg(artistId)));
        Pageable pageable = PageRequest.of(params.getPageNum() - 1, params.getPageSize());
        Page<Album> albumPage = albumRepository.findAlbumsByArtist(
                pageable, params.getSearch(), params.getSort(), artist.getId()
        );
        return pageMapper.toAlbumPageResponse(albumPage);
    }

    private Album fetchAlbumById(Long albumId) {
        return albumRepository.findById(albumId)
                .orElseThrow(() -> new ResourceNotFoundException(i18nUtils.getAlbumNotFoundMsg(albumId)));
    }

    private List<Artist> getArtistsByIds(List<Long> artistIds) {
        return artistIds.stream()
                .map(artistId -> artistRepository.findById(artistId)
                        .orElseThrow(() -> new ResourceNotFoundException(i18nUtils.getArtistNotFoundMsg(artistId))))
                .collect(Collectors.toList());
    }

}
