package com.xdpsx.music.service.impl;

import com.xdpsx.music.dto.request.params.ArtistParams;
import com.xdpsx.music.dto.request.ArtistRequest;
import com.xdpsx.music.model.entity.Artist;
import com.xdpsx.music.exception.ResourceNotFoundException;
import com.xdpsx.music.mapper.ArtistMapper;
import com.xdpsx.music.repository.ArtistRepository;
import com.xdpsx.music.service.ArtistService;
import com.xdpsx.music.service.FileService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import static com.xdpsx.music.constant.FileConstants.ARTISTS_IMG_FOLDER;

@Service
@RequiredArgsConstructor
public class ArtistServiceImpl implements ArtistService {
    private final FileService fileService;
    private final ArtistMapper artistMapper;
    private final ArtistRepository artistRepository;

    @Override
    public Page<Artist> getAllArtists(ArtistParams params) {
        Pageable pageable = PageRequest.of(params.getPageNum() - 1, params.getPageSize());
        return artistRepository.findWithFilters(
                pageable, params.getSearch(), params.getSort(), params.getGender()
        );
    }

    @Override
    public Artist getArtistById(Long id) {
        return artistRepository.findById(id)
                .orElse(null);
    }

    @Override
    public Artist createArtist(ArtistRequest request, MultipartFile image) {
        Artist artist = artistMapper.fromRequestToEntity(request);
        if (image != null){
            String imageUrl = fileService.uploadFile(image, ARTISTS_IMG_FOLDER);
            artist.setAvatar(imageUrl);
        }

        return artistRepository.save(artist);
    }

    @Override
    public Artist updateArtist(Long id, ArtistRequest request, MultipartFile image) {
        Artist artist = getArtistById(id);
        if (artist == null){
            throw new ResourceNotFoundException(String.format("Not found artist with ID=%s", id));
        }
        artist.setName(request.getName());
        artist.setGender(request.getGender());
        artist.setDescription(request.getDescription());
        artist.setDob(request.getDob());

        String oldImage = null;
        if (image != null){
            oldImage = artist.getAvatar();
            String imageUrl = fileService.uploadFile(image, ARTISTS_IMG_FOLDER);
            artist.setAvatar(imageUrl);
        }

        Artist savedArtist = artistRepository.save(artist);
        if (oldImage != null){
            fileService.deleteFileByUrl(oldImage);
        }
        return savedArtist;
    }

    @Override
    public void deleteArtist(Long id) {
        Artist artist = getArtistById(id);
        if (artist == null){
            throw new ResourceNotFoundException(String.format("Not found artist with ID=%s", id));
        }
        artistRepository.delete(artist);
        fileService.deleteFileByUrl(artist.getAvatar());
    }
}
