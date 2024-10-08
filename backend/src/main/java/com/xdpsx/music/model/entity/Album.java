package com.xdpsx.music.model.entity;

import com.xdpsx.music.dto.request.AlbumRequest;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.List;

@Setter
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "albums")
public class Album {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "album_id_seq_gen")
    @SequenceGenerator(name = "album_id_seq_gen", sequenceName = "albums_id_seq", allocationSize = 1)
    private Long id;

    @Column(length = 128, nullable = false)
    private String name;

    private String image;

    @Column(nullable = false)
    private LocalDate releaseDate;

    @ManyToOne
    @JoinColumn(name="genre_id", referencedColumnName = "id")
    private Genre genre;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = "artist_albums",
            joinColumns = @JoinColumn(name = "album_id", referencedColumnName = "id"),
            inverseJoinColumns = @JoinColumn(name = "artist_id", referencedColumnName = "id")
    )
    private List<Artist> artists;

    @OneToMany(mappedBy = "album")
    private List<Track> tracks;

    public void updateAlbum(AlbumRequest request){
        this.setName(request.getName());
        this.setReleaseDate(request.getReleaseDate());
    }
}
