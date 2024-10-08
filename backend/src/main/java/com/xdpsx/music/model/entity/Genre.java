package com.xdpsx.music.model.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "genres")
public class Genre {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "genre_id_seq_gen")
    @SequenceGenerator(name = "genre_id_seq_gen", sequenceName = "genres_id_seq", allocationSize = 1)
    private Integer id;

    @Column(length = 64, nullable = false, unique = true)
    private String name;

    private String image;

    @OneToMany(mappedBy = "genre")
    private List<Album> albums;

    @OneToMany(mappedBy = "genre")
    private List<Track> tracks;

}
