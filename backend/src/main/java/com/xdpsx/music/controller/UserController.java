package com.xdpsx.music.controller;

import com.xdpsx.music.dto.common.ErrorDTO;
import com.xdpsx.music.dto.common.ErrorDetails;
import com.xdpsx.music.dto.common.PageResponse;
import com.xdpsx.music.dto.request.ChangePasswordRequest;
import com.xdpsx.music.dto.request.UserProfileRequest;
import com.xdpsx.music.dto.request.params.TrackParams;
import com.xdpsx.music.dto.request.params.UserParams;
import com.xdpsx.music.dto.response.MessageResponse;
import com.xdpsx.music.dto.response.TrackResponse;
import com.xdpsx.music.dto.response.UserProfileResponse;
import com.xdpsx.music.dto.response.UserResponse;
import com.xdpsx.music.model.entity.User;
import com.xdpsx.music.security.UserContext;
import com.xdpsx.music.service.TrackService;
import com.xdpsx.music.service.UserService;
import com.xdpsx.music.util.I18nUtils;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

@Tag(name = "REST APIs for User")
@SecurityRequirement(name = "JWT")
@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {

    private final UserContext userContext;
    private final UserService userService;
    private final TrackService trackService;
    private final I18nUtils i18nUtils;

    @Operation(summary = "Change account password")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Ok",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = MessageResponse.class))
            ),
            @ApiResponse(responseCode = "400", description = "Bad Request",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(oneOf = { ErrorDTO.class, ErrorDetails.class })
                    )),
    })
    @PatchMapping("/change-password")
    public ResponseEntity<MessageResponse> changePassword(
            @Valid @RequestBody ChangePasswordRequest request
    ){
        User loggedUser = userContext.getLoggedUser();
        userService.changePassword(request, loggedUser);
        return ResponseEntity.ok(new MessageResponse(i18nUtils.getChangePwSucMsg()));
    }

    @Operation(summary = "Get user profile")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Ok",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = UserProfileResponse.class))
            )
    })
    @GetMapping("/profile")
    public ResponseEntity<UserProfileResponse> getUserProfile() {
        User loggedUser = userContext.getLoggedUser();
        UserProfileResponse response = userService.getUserProfile(loggedUser);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "Update user profile")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Ok",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = UserProfileResponse.class))
            ),
            @ApiResponse(responseCode = "400", description = "Bad Request",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = ErrorDetails.class )
                    )),
    })
    @PutMapping(path="/profile", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<UserProfileResponse> updateUserProfile(
            @ParameterObject @Valid @ModelAttribute UserProfileRequest request,
            @RequestParam(required = false) MultipartFile image) {
        User loggedUser = userContext.getLoggedUser();
        UserProfileResponse response = userService.updateUserProfile(loggedUser, request, image);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "Lock user account", description = "Need Role Admin")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Ok",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = MessageResponse.class))
            ),
            @ApiResponse(responseCode = "400", description = "Bad Request",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = ErrorDTO.class)
                    )),
            @ApiResponse(responseCode = "404", description = "Not Found",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = ErrorDTO.class)
                    )),
    })
    @PutMapping("/{userId}/lock")
    public ResponseEntity<MessageResponse> lockUser(@PathVariable Long userId) {
        userService.lockUser(userId);
        return ResponseEntity.ok(new MessageResponse(i18nUtils.getLockAccountSucMsg()));
    }

    @Operation(summary = "Unlock user account", description = "Need Role Admin")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Ok",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = MessageResponse.class))
            ),
            @ApiResponse(responseCode = "400", description = "Bad Request",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = ErrorDTO.class)
                    )),
            @ApiResponse(responseCode = "404", description = "Not Found",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = ErrorDTO.class)
                    )),
    })
    @PutMapping("/{userId}/unlock")
    public ResponseEntity<MessageResponse> unlockUser(@PathVariable Long userId) {
        userService.unlockUser(userId);
        return ResponseEntity.ok(new MessageResponse(i18nUtils.getUnlockAccountSucMsg()));
    }

    @Operation(summary = "Delete user by id", description = "Need Role Admin")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204", description = "No Content"),
            @ApiResponse(responseCode = "404", description = "Not Found",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = ErrorDTO.class)
                    )),
    })
    @DeleteMapping("/{userId}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long userId){
        userService.deleteUserById(userId);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Get all users", description = "Need Role Admin")
    @GetMapping
    public ResponseEntity<PageResponse<UserResponse>> getAllUsers(
            @ParameterObject @Valid UserParams params
    ){
        PageResponse<UserResponse> responses = userService.getAllUsers(params);
        String baseUri = ServletUriComponentsBuilder.fromCurrentRequestUri().toUriString();
        responses.addPaginationLinks(baseUri);
        return ResponseEntity.ok(responses);
    }

    @Operation(summary = "Get user's favorite tracks")
    @GetMapping("/me/favorites")
    public ResponseEntity<PageResponse<TrackResponse>> getFavoriteTracks(
            @ParameterObject @Valid TrackParams params
    ){
        User loggedUser = userContext.getLoggedUser();
        PageResponse<TrackResponse> responses = trackService.getLikedTracks(params, loggedUser);
        String baseUri = ServletUriComponentsBuilder.fromCurrentRequestUri().toUriString();
        responses.addPaginationLinks(baseUri);
        return ResponseEntity.ok(responses);
    }
}
