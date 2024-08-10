package com.xdpsx.music.dto.response;

import com.xdpsx.music.model.enums.Gender;
import lombok.*;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ArtistResponse implements Serializable {
    private Long id;
    private String name;
    private String avatar;
    private Gender gender;
    private String description;
    private LocalDate dob;
    private LocalDateTime createdAt;
}
