PGDMP      &    
            |         	   music_app    16.4 (Debian 16.4-1.pgdg120+1)    16.2 w    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16384 	   music_app    DATABASE     t   CREATE DATABASE music_app WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';
    DROP DATABASE music_app;
                xdpsx    false            �            1255    16389 5   adjust_playlist_tracks_track_numbers_after_deletion()    FUNCTION     ,  CREATE FUNCTION public.adjust_playlist_tracks_track_numbers_after_deletion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE playlist_tracks
    SET track_number = track_number - 1
    WHERE playlist_id = OLD.playlist_id AND track_number > OLD.track_number;

    RETURN OLD;
END;
$$;
 L   DROP FUNCTION public.adjust_playlist_tracks_track_numbers_after_deletion();
       public          xdpsx    false            �            1255    16390 ,   adjust_tracks_track_numbers_after_deletion()    FUNCTION       CREATE FUNCTION public.adjust_tracks_track_numbers_after_deletion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE tracks
    SET track_number = track_number - 1
    WHERE album_id = OLD.album_id AND track_number > OLD.track_number;

    RETURN OLD;
END;
$$;
 C   DROP FUNCTION public.adjust_tracks_track_numbers_after_deletion();
       public          xdpsx    false            �            1255    16391 '   adjust_tracks_track_numbers_on_update()    FUNCTION     ^  CREATE FUNCTION public.adjust_tracks_track_numbers_on_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF OLD.album_id IS DISTINCT FROM NEW.album_id THEN
        UPDATE tracks
        SET track_number = track_number - 1
        WHERE album_id = OLD.album_id AND track_number > OLD.track_number;
    END IF;

    RETURN NEW;
END;
$$;
 >   DROP FUNCTION public.adjust_tracks_track_numbers_on_update();
       public          xdpsx    false            �            1255    16392    revoke_old_confirm_tokens()    FUNCTION     �   CREATE FUNCTION public.revoke_old_confirm_tokens() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE confirm_tokens
    SET revoked = true
    WHERE user_id = NEW.user_id;
    
    RETURN NEW;
END;
$$;
 2   DROP FUNCTION public.revoke_old_confirm_tokens();
       public          xdpsx    false            �            1255    16393    revoke_old_tokens()    FUNCTION     �   CREATE FUNCTION public.revoke_old_tokens() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE tokens
    SET revoked = true
    WHERE user_id = NEW.user_id;
    
    RETURN NEW;
END;
$$;
 *   DROP FUNCTION public.revoke_old_tokens();
       public          xdpsx    false            �            1255    16394    revoke_tokens_on_account_lock()    FUNCTION       CREATE FUNCTION public.revoke_tokens_on_account_lock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.account_locked = TRUE THEN
        UPDATE tokens
        SET revoked = TRUE
        WHERE user_id = NEW.id;
    END IF;
    RETURN NEW;
END;
$$;
 6   DROP FUNCTION public.revoke_tokens_on_account_lock();
       public          xdpsx    false            �            1259    16395    albums    TABLE     �   CREATE TABLE public.albums (
    id bigint NOT NULL,
    name character varying(128) NOT NULL,
    image character varying(255),
    release_date date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    genre_id integer
);
    DROP TABLE public.albums;
       public         heap    xdpsx    false            �            1259    16399    albums_id_seq    SEQUENCE     v   CREATE SEQUENCE public.albums_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.albums_id_seq;
       public          xdpsx    false    215            �           0    0    albums_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.albums_id_seq OWNED BY public.albums.id;
          public          xdpsx    false    216            �            1259    16400    artist_albums    TABLE     c   CREATE TABLE public.artist_albums (
    artist_id bigint NOT NULL,
    album_id bigint NOT NULL
);
 !   DROP TABLE public.artist_albums;
       public         heap    xdpsx    false            �            1259    16403    artist_tracks    TABLE     c   CREATE TABLE public.artist_tracks (
    artist_id bigint NOT NULL,
    track_id bigint NOT NULL
);
 !   DROP TABLE public.artist_tracks;
       public         heap    xdpsx    false            �            1259    16406    artists    TABLE     #  CREATE TABLE public.artists (
    id bigint NOT NULL,
    name character varying(128) NOT NULL,
    avatar character varying(255),
    gender character varying(16) NOT NULL,
    description text,
    dob date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE public.artists;
       public         heap    xdpsx    false            �            1259    16412    artists_id_seq    SEQUENCE     w   CREATE SEQUENCE public.artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.artists_id_seq;
       public          xdpsx    false    219            �           0    0    artists_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.artists_id_seq OWNED BY public.artists.id;
          public          xdpsx    false    220            �            1259    16413    confirm_tokens    TABLE     <  CREATE TABLE public.confirm_tokens (
    id bigint NOT NULL,
    code character varying NOT NULL,
    revoked boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    expired_at timestamp without time zone NOT NULL,
    validated_at timestamp without time zone,
    user_id bigint NOT NULL
);
 "   DROP TABLE public.confirm_tokens;
       public         heap    xdpsx    false            �            1259    16419    confirm_tokens_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.confirm_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.confirm_tokens_id_seq;
       public          xdpsx    false    221            �           0    0    confirm_tokens_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.confirm_tokens_id_seq OWNED BY public.confirm_tokens.id;
          public          xdpsx    false    222            �            1259    16420    flyway_schema_history    TABLE     �  CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);
 )   DROP TABLE public.flyway_schema_history;
       public         heap    xdpsx    false            �            1259    16426    genres    TABLE     �   CREATE TABLE public.genres (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    image character varying(255)
);
    DROP TABLE public.genres;
       public         heap    xdpsx    false            �            1259    16429    genres_id_seq    SEQUENCE     �   CREATE SEQUENCE public.genres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.genres_id_seq;
       public          xdpsx    false    224            �           0    0    genres_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.genres_id_seq OWNED BY public.genres.id;
          public          xdpsx    false    225            �            1259    16430    likes    TABLE     �   CREATE TABLE public.likes (
    user_id bigint NOT NULL,
    track_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE public.likes;
       public         heap    xdpsx    false            �            1259    16434    playlist_tracks    TABLE     �   CREATE TABLE public.playlist_tracks (
    playlist_id bigint NOT NULL,
    track_id bigint NOT NULL,
    track_number integer NOT NULL
);
 #   DROP TABLE public.playlist_tracks;
       public         heap    xdpsx    false            �            1259    16437 	   playlists    TABLE     �   CREATE TABLE public.playlists (
    id bigint NOT NULL,
    name character varying(128) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone,
    owner_id bigint
);
    DROP TABLE public.playlists;
       public         heap    xdpsx    false            �            1259    16441    playlists_id_seq    SEQUENCE     y   CREATE SEQUENCE public.playlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.playlists_id_seq;
       public          xdpsx    false    228            �           0    0    playlists_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.playlists_id_seq OWNED BY public.playlists.id;
          public          xdpsx    false    229            �            1259    16442    roles    TABLE     a   CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(128) NOT NULL
);
    DROP TABLE public.roles;
       public         heap    xdpsx    false            �            1259    16445    roles_id_seq    SEQUENCE     �   CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.roles_id_seq;
       public          xdpsx    false    230            �           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
          public          xdpsx    false    231            �            1259    16446    tokens    TABLE     �   CREATE TABLE public.tokens (
    id bigint NOT NULL,
    access_token character varying(255) NOT NULL,
    refresh_token character varying(255) NOT NULL,
    revoked boolean DEFAULT false,
    user_id bigint
);
    DROP TABLE public.tokens;
       public         heap    xdpsx    false            �            1259    16452    tokens_id_seq    SEQUENCE     v   CREATE SEQUENCE public.tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.tokens_id_seq;
       public          xdpsx    false    232            �           0    0    tokens_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;
          public          xdpsx    false    233            �            1259    16453    tracks    TABLE     �  CREATE TABLE public.tracks (
    id bigint NOT NULL,
    name character varying(128) NOT NULL,
    duration_ms integer NOT NULL,
    image character varying(255),
    url character varying(255) NOT NULL,
    listening_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    track_number integer,
    album_id bigint,
    genre_id integer
);
    DROP TABLE public.tracks;
       public         heap    xdpsx    false            �            1259    16460    tracks_id_seq    SEQUENCE     v   CREATE SEQUENCE public.tracks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.tracks_id_seq;
       public          xdpsx    false    234            �           0    0    tracks_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.tracks_id_seq OWNED BY public.tracks.id;
          public          xdpsx    false    235            �            1259    16461    users    TABLE     �  CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(128) NOT NULL,
    avatar character varying(255),
    email character varying(128) NOT NULL,
    password character varying(255) NOT NULL,
    account_locked boolean DEFAULT false,
    enabled boolean DEFAULT false,
    role_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone
);
    DROP TABLE public.users;
       public         heap    xdpsx    false            �            1259    16469    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          xdpsx    false    236            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          xdpsx    false    237            �           2604    16470 	   albums id    DEFAULT     f   ALTER TABLE ONLY public.albums ALTER COLUMN id SET DEFAULT nextval('public.albums_id_seq'::regclass);
 8   ALTER TABLE public.albums ALTER COLUMN id DROP DEFAULT;
       public          xdpsx    false    216    215            �           2604    16471 
   artists id    DEFAULT     h   ALTER TABLE ONLY public.artists ALTER COLUMN id SET DEFAULT nextval('public.artists_id_seq'::regclass);
 9   ALTER TABLE public.artists ALTER COLUMN id DROP DEFAULT;
       public          xdpsx    false    220    219            �           2604    16472    confirm_tokens id    DEFAULT     v   ALTER TABLE ONLY public.confirm_tokens ALTER COLUMN id SET DEFAULT nextval('public.confirm_tokens_id_seq'::regclass);
 @   ALTER TABLE public.confirm_tokens ALTER COLUMN id DROP DEFAULT;
       public          xdpsx    false    222    221            �           2604    16473 	   genres id    DEFAULT     f   ALTER TABLE ONLY public.genres ALTER COLUMN id SET DEFAULT nextval('public.genres_id_seq'::regclass);
 8   ALTER TABLE public.genres ALTER COLUMN id DROP DEFAULT;
       public          xdpsx    false    225    224            �           2604    16474    playlists id    DEFAULT     l   ALTER TABLE ONLY public.playlists ALTER COLUMN id SET DEFAULT nextval('public.playlists_id_seq'::regclass);
 ;   ALTER TABLE public.playlists ALTER COLUMN id DROP DEFAULT;
       public          xdpsx    false    229    228            �           2604    16475    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          xdpsx    false    231    230            �           2604    16476 	   tokens id    DEFAULT     f   ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);
 8   ALTER TABLE public.tokens ALTER COLUMN id DROP DEFAULT;
       public          xdpsx    false    233    232            �           2604    16477 	   tracks id    DEFAULT     f   ALTER TABLE ONLY public.tracks ALTER COLUMN id SET DEFAULT nextval('public.tracks_id_seq'::regclass);
 8   ALTER TABLE public.tracks ALTER COLUMN id DROP DEFAULT;
       public          xdpsx    false    235    234            �           2604    16478    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          xdpsx    false    237    236            �          0    16395    albums 
   TABLE DATA           I   COPY public.albums (id, name, image, release_date, genre_id) FROM stdin;
    public          xdpsx    false    215   ��       �          0    16400    artist_albums 
   TABLE DATA           <   COPY public.artist_albums (artist_id, album_id) FROM stdin;
    public          xdpsx    false    217   Z�       �          0    16403    artist_tracks 
   TABLE DATA           <   COPY public.artist_tracks (artist_id, track_id) FROM stdin;
    public          xdpsx    false    218   �       �          0    16406    artists 
   TABLE DATA           Y   COPY public.artists (id, name, avatar, gender, description, dob, created_at) FROM stdin;
    public          xdpsx    false    219   ��       �          0    16413    confirm_tokens 
   TABLE DATA           j   COPY public.confirm_tokens (id, code, revoked, created_at, expired_at, validated_at, user_id) FROM stdin;
    public          xdpsx    false    221   ˸       �          0    16420    flyway_schema_history 
   TABLE DATA           �   COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
    public          xdpsx    false    223   �       �          0    16426    genres 
   TABLE DATA           1   COPY public.genres (id, name, image) FROM stdin;
    public          xdpsx    false    224   P�       �          0    16430    likes 
   TABLE DATA           >   COPY public.likes (user_id, track_id, created_at) FROM stdin;
    public          xdpsx    false    226   �       �          0    16434    playlist_tracks 
   TABLE DATA           N   COPY public.playlist_tracks (playlist_id, track_id, track_number) FROM stdin;
    public          xdpsx    false    227   `�       �          0    16437 	   playlists 
   TABLE DATA           O   COPY public.playlists (id, name, created_at, updated_at, owner_id) FROM stdin;
    public          xdpsx    false    228   x�       �          0    16442    roles 
   TABLE DATA           )   COPY public.roles (id, name) FROM stdin;
    public          xdpsx    false    230   ��       �          0    16446    tokens 
   TABLE DATA           S   COPY public.tokens (id, access_token, refresh_token, revoked, user_id) FROM stdin;
    public          xdpsx    false    232   �       �          0    16453    tracks 
   TABLE DATA           �   COPY public.tracks (id, name, duration_ms, image, url, listening_count, created_at, track_number, album_id, genre_id) FROM stdin;
    public          xdpsx    false    234   I�       �          0    16461    users 
   TABLE DATA           |   COPY public.users (id, name, avatar, email, password, account_locked, enabled, role_id, created_at, updated_at) FROM stdin;
    public          xdpsx    false    236   Ew      �           0    0    albums_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.albums_id_seq', 167, true);
          public          xdpsx    false    216            �           0    0    artists_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.artists_id_seq', 70, true);
          public          xdpsx    false    220            �           0    0    confirm_tokens_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.confirm_tokens_id_seq', 1, false);
          public          xdpsx    false    222            �           0    0    genres_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.genres_id_seq', 9, true);
          public          xdpsx    false    225            �           0    0    playlists_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.playlists_id_seq', 189, true);
          public          xdpsx    false    229            �           0    0    roles_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.roles_id_seq', 2, true);
          public          xdpsx    false    231            �           0    0    tokens_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.tokens_id_seq', 4, true);
          public          xdpsx    false    233            �           0    0    tracks_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.tracks_id_seq', 1372, true);
          public          xdpsx    false    235            �           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 81, true);
          public          xdpsx    false    237            �           2606    16480    albums albums_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.albums DROP CONSTRAINT albums_pkey;
       public            xdpsx    false    215            �           2606    16482     artist_albums artist_albums_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.artist_albums
    ADD CONSTRAINT artist_albums_pkey PRIMARY KEY (artist_id, album_id);
 J   ALTER TABLE ONLY public.artist_albums DROP CONSTRAINT artist_albums_pkey;
       public            xdpsx    false    217    217            �           2606    16484     artist_tracks artist_tracks_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.artist_tracks
    ADD CONSTRAINT artist_tracks_pkey PRIMARY KEY (artist_id, track_id);
 J   ALTER TABLE ONLY public.artist_tracks DROP CONSTRAINT artist_tracks_pkey;
       public            xdpsx    false    218    218            �           2606    16486    artists artists_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.artists DROP CONSTRAINT artists_pkey;
       public            xdpsx    false    219            �           2606    16488 "   confirm_tokens confirm_tokens_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.confirm_tokens
    ADD CONSTRAINT confirm_tokens_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.confirm_tokens DROP CONSTRAINT confirm_tokens_pkey;
       public            xdpsx    false    221            �           2606    16490 .   flyway_schema_history flyway_schema_history_pk 
   CONSTRAINT     x   ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);
 X   ALTER TABLE ONLY public.flyway_schema_history DROP CONSTRAINT flyway_schema_history_pk;
       public            xdpsx    false    223            �           2606    16492    genres genres_name_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_name_key UNIQUE (name);
 @   ALTER TABLE ONLY public.genres DROP CONSTRAINT genres_name_key;
       public            xdpsx    false    224            �           2606    16494    genres genres_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.genres DROP CONSTRAINT genres_pkey;
       public            xdpsx    false    224            �           2606    16496    likes likes_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (user_id, track_id);
 :   ALTER TABLE ONLY public.likes DROP CONSTRAINT likes_pkey;
       public            xdpsx    false    226    226            �           2606    16498 $   playlist_tracks playlist_tracks_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.playlist_tracks
    ADD CONSTRAINT playlist_tracks_pkey PRIMARY KEY (playlist_id, track_id);
 N   ALTER TABLE ONLY public.playlist_tracks DROP CONSTRAINT playlist_tracks_pkey;
       public            xdpsx    false    227    227            �           2606    16500    playlists playlists_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT playlists_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.playlists DROP CONSTRAINT playlists_pkey;
       public            xdpsx    false    228            �           2606    16502    roles roles_name_key 
   CONSTRAINT     O   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);
 >   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_name_key;
       public            xdpsx    false    230            �           2606    16504    roles roles_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
       public            xdpsx    false    230            �           2606    16506    tokens tokens_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.tokens DROP CONSTRAINT tokens_pkey;
       public            xdpsx    false    232            �           2606    16508    tracks tracks_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.tracks DROP CONSTRAINT tracks_pkey;
       public            xdpsx    false    234                        2606    16510    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            xdpsx    false    236                       2606    16512    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            xdpsx    false    236            �           1259    16513    flyway_schema_history_s_idx    INDEX     `   CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);
 /   DROP INDEX public.flyway_schema_history_s_idx;
       public            xdpsx    false    223            �           1259    16514    idx_playlists_id_owner_id    INDEX     W   CREATE INDEX idx_playlists_id_owner_id ON public.playlists USING btree (id, owner_id);
 -   DROP INDEX public.idx_playlists_id_owner_id;
       public            xdpsx    false    228    228            �           1259    16515    idx_tokens_access_token    INDEX     R   CREATE INDEX idx_tokens_access_token ON public.tokens USING btree (access_token);
 +   DROP INDEX public.idx_tokens_access_token;
       public            xdpsx    false    232            �           1259    16516    idx_tokens_refresh_token    INDEX     T   CREATE INDEX idx_tokens_refresh_token ON public.tokens USING btree (refresh_token);
 ,   DROP INDEX public.idx_tokens_refresh_token;
       public            xdpsx    false    232            �           1259    16517    idx_tracks_album_id    INDEX     J   CREATE INDEX idx_tracks_album_id ON public.tracks USING btree (album_id);
 '   DROP INDEX public.idx_tracks_album_id;
       public            xdpsx    false    234            �           1259    16518     idx_tracks_album_id_track_number    INDEX     e   CREATE INDEX idx_tracks_album_id_track_number ON public.tracks USING btree (album_id, track_number);
 4   DROP INDEX public.idx_tracks_album_id_track_number;
       public            xdpsx    false    234    234            �           1259    16519    idx_tracks_genre_id    INDEX     J   CREATE INDEX idx_tracks_genre_id ON public.tracks USING btree (genre_id);
 '   DROP INDEX public.idx_tracks_genre_id;
       public            xdpsx    false    234                       2620    16520 ,   playlist_tracks before_delete_playlist_track    TRIGGER     �   CREATE TRIGGER before_delete_playlist_track BEFORE DELETE ON public.playlist_tracks FOR EACH ROW EXECUTE FUNCTION public.adjust_playlist_tracks_track_numbers_after_deletion();
 E   DROP TRIGGER before_delete_playlist_track ON public.playlist_tracks;
       public          xdpsx    false    238    227                       2620    16521    tracks before_delete_track    TRIGGER     �   CREATE TRIGGER before_delete_track BEFORE DELETE ON public.tracks FOR EACH ROW WHEN (((old.album_id IS NOT NULL) AND (old.track_number IS NOT NULL))) EXECUTE FUNCTION public.adjust_tracks_track_numbers_after_deletion();
 3   DROP TRIGGER before_delete_track ON public.tracks;
       public          xdpsx    false    234    234    234    239                       2620    16522 *   confirm_tokens before_insert_confirm_token    TRIGGER     �   CREATE TRIGGER before_insert_confirm_token BEFORE INSERT ON public.confirm_tokens FOR EACH ROW EXECUTE FUNCTION public.revoke_old_confirm_tokens();
 C   DROP TRIGGER before_insert_confirm_token ON public.confirm_tokens;
       public          xdpsx    false    241    221                       2620    16523    tokens before_insert_token    TRIGGER     |   CREATE TRIGGER before_insert_token BEFORE INSERT ON public.tokens FOR EACH ROW EXECUTE FUNCTION public.revoke_old_tokens();
 3   DROP TRIGGER before_insert_token ON public.tokens;
       public          xdpsx    false    232    242                       2620    16524    tracks before_update_track    TRIGGER     �   CREATE TRIGGER before_update_track BEFORE UPDATE ON public.tracks FOR EACH ROW WHEN (((old.album_id IS NOT NULL) AND (old.track_number IS NOT NULL))) EXECUTE FUNCTION public.adjust_tracks_track_numbers_on_update();
 3   DROP TRIGGER before_update_track ON public.tracks;
       public          xdpsx    false    234    234    240    234                       2620    16525 #   users update_tokens_on_account_lock    TRIGGER     �   CREATE TRIGGER update_tokens_on_account_lock AFTER UPDATE OF account_locked ON public.users FOR EACH ROW EXECUTE FUNCTION public.revoke_tokens_on_account_lock();
 <   DROP TRIGGER update_tokens_on_account_lock ON public.users;
       public          xdpsx    false    243    236    236                       2606    16526    albums albums_genre_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genres(id) ON DELETE SET NULL;
 E   ALTER TABLE ONLY public.albums DROP CONSTRAINT albums_genre_id_fkey;
       public          xdpsx    false    224    215    3306                       2606    16531 )   artist_albums artist_albums_album_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.artist_albums
    ADD CONSTRAINT artist_albums_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.albums(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.artist_albums DROP CONSTRAINT artist_albums_album_id_fkey;
       public          xdpsx    false    3291    217    215                       2606    16536 *   artist_albums artist_albums_artist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.artist_albums
    ADD CONSTRAINT artist_albums_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artists(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.artist_albums DROP CONSTRAINT artist_albums_artist_id_fkey;
       public          xdpsx    false    219    217    3297                       2606    16541 *   artist_tracks artist_tracks_artist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.artist_tracks
    ADD CONSTRAINT artist_tracks_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artists(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.artist_tracks DROP CONSTRAINT artist_tracks_artist_id_fkey;
       public          xdpsx    false    218    219    3297                       2606    16546 )   artist_tracks artist_tracks_track_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.artist_tracks
    ADD CONSTRAINT artist_tracks_track_id_fkey FOREIGN KEY (track_id) REFERENCES public.tracks(id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.artist_tracks DROP CONSTRAINT artist_tracks_track_id_fkey;
       public          xdpsx    false    218    3326    234                       2606    16551 *   confirm_tokens confirm_tokens_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.confirm_tokens
    ADD CONSTRAINT confirm_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.confirm_tokens DROP CONSTRAINT confirm_tokens_user_id_fkey;
       public          xdpsx    false    3330    236    221            	           2606    16556    likes likes_track_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_track_id_fkey FOREIGN KEY (track_id) REFERENCES public.tracks(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.likes DROP CONSTRAINT likes_track_id_fkey;
       public          xdpsx    false    3326    234    226            
           2606    16561    likes likes_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.likes DROP CONSTRAINT likes_user_id_fkey;
       public          xdpsx    false    3330    226    236                       2606    16566 0   playlist_tracks playlist_tracks_playlist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.playlist_tracks
    ADD CONSTRAINT playlist_tracks_playlist_id_fkey FOREIGN KEY (playlist_id) REFERENCES public.playlists(id) ON DELETE CASCADE;
 Z   ALTER TABLE ONLY public.playlist_tracks DROP CONSTRAINT playlist_tracks_playlist_id_fkey;
       public          xdpsx    false    228    227    3313                       2606    16571 -   playlist_tracks playlist_tracks_track_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.playlist_tracks
    ADD CONSTRAINT playlist_tracks_track_id_fkey FOREIGN KEY (track_id) REFERENCES public.tracks(id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.playlist_tracks DROP CONSTRAINT playlist_tracks_track_id_fkey;
       public          xdpsx    false    3326    227    234                       2606    16576 !   playlists playlists_owner_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT playlists_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.playlists DROP CONSTRAINT playlists_owner_id_fkey;
       public          xdpsx    false    236    3330    228                       2606    16581    tokens tokens_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.tokens DROP CONSTRAINT tokens_user_id_fkey;
       public          xdpsx    false    236    3330    232                       2606    16586    tracks tracks_album_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.albums(id) ON DELETE SET NULL;
 E   ALTER TABLE ONLY public.tracks DROP CONSTRAINT tracks_album_id_fkey;
       public          xdpsx    false    234    3291    215                       2606    16591    tracks tracks_genre_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genres(id) ON DELETE SET NULL;
 E   ALTER TABLE ONLY public.tracks DROP CONSTRAINT tracks_genre_id_fkey;
       public          xdpsx    false    234    3306    224                       2606    16596    users users_role_id_fkey    FK CONSTRAINT     w   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_role_id_fkey;
       public          xdpsx    false    230    3317    236            �      x��Z�n�H��n?E_-�F�sn�x�xg��3��h�-�#����j_c_o�d��&%�$�E QW��U_}UE������E�ٶ�����{��|7��Deb#�c��;�Ԥ"��o��ן8��0��c�G��,��V�j��D��ZE)�B(�ٝ�7��u�_t&���Vrr �V�t��N��A�J沸��leZs:�;���=oE���¿���%�M�I�V�b�xP=S��KU)��t�[�F��L\��w��oUV�(�'U�򒞸�����\�ǅ�yG�����J��H_L����Թ�z�I�[Y^���� Ҿ�k�����g�*��8��g�':�{�����Fp���D����w]�,��.����e�&%�5z�)��H���(RY^2��i��{�vdh�g˽;�E.� �Lr}h��ܼ	7`_erao!�v�gvy�[�Ņm�|?�G�N�}]	�Ëm�ζ�w6�9c���ŐKi�&~�v�ٽNw�y�ڍ�9J�Ys[F�]�/�N�y�� �m��������ʢī����O����9{��[�C\���}w���;�D�V�B���u\��f#@�N+��o6g�L[�a�;��yi{b$:��������)��T�ta.��O��&���\O;W?!�o���Z�� �D0��SvSWu��?E��W��F���E��{�ʜ�H~���^��M�J���c���N�����+ ���T�*��HWu�yK�y��}����Db2�O4m�|�ofM�]P�}�E�p����V��ʣ��+YD��@�g<��\:t�J<�u�}++u��E����u�d�3{+���B�%�C���=�����Ju"�J����7��v�oV�c�������b�"�E�b��3��C���.����J�uA��Hv^��P�Oٲ ^ <#�Q�T�"��L��J찮��K�~U�"����B��p,��s�U?yx!z�oP�_����P�
�i�a+�"�'��O��g �����u�rQ����G��:\oam�lI����^VԻ׹��ف�^�)Fb���`dz��1o��s���И[}�b'�c��Eq�t.�|�b��"س��7��B�쒂�
vB|n�`�'0����$�!�o��EU�[��f������)��e���5v6�$��'�[0gwZO^��(�G�S�#��*�\G�!J���%��������D��;���/i�O��5��a^��?���/�����#	��B���{�푊�m�����-:���E���P�a�?+@.�;d!���즨�za�0'hHk�ߴ��K��f:/2{C*-P�u��x���:�ڬN-p����H(o��#�8����p����y����:���PAc�ys���/���甤�S�"c��V$�C=��5�{�ğ�"��-C�I��-uA7 	�xWS�=>����A7�p��"=�t�[]TQ�Wi0�^m��.����E���˽4�d*�E�VD�V�U��֨�U%�<�
�j��E�l��0h*����*����O8���AJ�g�,��3}�k���|J��6L��8���wN)�ٓ�±p�۴^1�0F��#��Vl5-�.�5٭��,�m!5��`�R���A	8-���/k�|3��m�kM+PZ�]@8*�p�o6�}3)�^U?p��q�,�5�9��C�R{���J�'Ih@����lm0;?n*�^p�A�uj��t;�"+��l
��lo�.���P���G������r+������Ö�l����횇CL���U�Q�Z-s�k�rdp5s���^+9L���P�2�v�la:HN�
X/(��U]lPK����r"�F��h����y��Q�Š��B�[�WTy5�K��y;��P�|����E����r�;4�5w>����&����轮���QFY�6���;,��M�g0:�Un\b�yx�(=�? �m@Bˌ=�U��1:�X�*��ɬIwT�`��4I$["˱�m�׼��d@jl�u�w*��g�7���XUC�ځI��� ��h@f��	��{��Ie{��m
]�G��7����0m߾����}��J�c���_����hc�)�LC��k@k�?���|)�X-�����F�5<���D�Q�D;�:��#., �ɭ�weF�o��^ͩA�1�rW���;�1����ġ�!ʟ<A*����U5�])�L�aT�N�ϣrj�WP)�rq"�
�|m�6����1f'�[նz+�̙Ը�eU��N�"=%ms����w�WDW)'�F����D�]��Y�����%�/`mI�k3��4�\�X8@����G��X>SYv��T��t�mIeS���rQi�#�D��A�J�
L�P�W(�!ܪ��j<�-cEc�'@����h��­��gU~�Y���0��(�&�6�95����j��S2�X6s�:S> �P]�����;����}*�ƺH�R��6�!�$��[ZgltNٝ�r0�Ͷ��?�R��qJ���Te�
�
��4٠�=+�Yw�")��I�Dx�|kk�Z�/�Z�[��Û+��̔�C���U}�hy�2���HF��/$�*7<���㰛5����
+h/T�Εo��0��wq����;��NлM���7�3^�k�5�?�8���Y][�� -��밒��ϝ�k�.י��4�ii��^�q�4cy;��������t@��c����~�jn��yK�O������7��2BD�U�2�� 3���v��)��G\�0���#;	�4���^#=#�~���~��u�4����,��I�+���Њh����ɮ��Ac�-�1�W�Ȣ�$@�I�?���4��D�#c��Y�t�f�c�V�Pe9�
�N�<�����X�*n[i�z��	���E�u�9QBR3e��}PE��%��E�{m ��D]��Ue�ZfgfZ�h1�鱻m�t7_��ȐW�c�6�l8Y
z1V	؅B8�{i�U���+�&Q��;�$8��4��g:�m��(��Wu ͵MKL������1�Ҹ;�u^�'}E��#Z�t���,��z8υ�w�Q�P��QE�D\��m�/!���*��K#�zZ�u���֣^��ol?�.����?�T�#o����b�u ��a�x�4v23'~��5/��୑ �V���y��s�G�*�P���f�S�����B�9<xܮ����\�`]L����m1�W��n�s˔�+��}l�X�]ޚ�N��� ո'N{[H��8W�BǸ�f$NS��Ao�T����?��V�dwx6m������?F����[8��ĆV��ƣ]�:���iD��!{J��B�Ї�v���;��m�&M ��Ij�>�_��hx���TN��F�IVM�}#�c*�s�h�Z�أ:�uw�Um���*ǡ��J��D(r��P����?kUѧ(��%����_"ټ�r�Pfy0�I>�kz���|�˽*d�WGK%5�*P�S�e��h2�� ��	hɓ�&O�c"�}�[����3��~�5ȥ����v	'�v�X�&fQ�ah����9�<���}/%��6�U$O��og�nP�h�r��P�"m�>�@z�&ă�Y�#���둙��,� �׭;�O�i;����S�8ҙnR+�?ɑ�\BBt.a���<�����I����@�����:Ӈv��sfH��^����(�֪��O,�=����NJ^4@�7U��FH����a����eEG�����|�=v'SU�zh��Y�� ����тB}�����]>7��o},�)�� �u���C��!��[���i��Q��.F�3f9���N͵h�%�w���#�����oR���;I©`�u?�P���pμ�s{%��K����<��)��fY�Tu�i���~B�Y���:�zl�ӈE�Y�Uh:2͇f�>}�������f��S������)�A���N���K{O���J&'L���xw#%\ٮ�����4�y�u O   ��T����R�9�~E7��8��/d:ӕ6m�j$W����.mw�Jv�8m��r/b���Z�.�B'W�6G�����տ���      �   v  x�%�ˍ�@�M0+0|ry�Ǳ�p�J�e$�}p�@9�q��'9�i��Dq�@6��� 5hB?1���>�����B��op:0	��$,9()X��@��6��ĀW|�z��������菼^q�1K��[L<���<�"xW ���%"�
�b�(����W�7��;��/��yK"�����o�l>�	��M����+�oC�oS���$���$}$.Z%�d�h}%�p?4���w���U�a���te+�X�]�*W��T?�"Og�b}��|�z�}��S�j�O��N#�JW����\ժ�X%u�te+na ,�S�rU+na<���Y�[���tW���0�l4-��S�Q�R~"�k���      �   �	  x�U�K�W���b� �7���_Ge�{���M���H�`���ǿW|��^���{��z�k���n�'�~��g�~���~����;��p���3�?���3�?#Έ3�8g�qF�g�qF��g��_�yF��g�yF�Qg�uF�}F�Qg�uF��g�}F���}:���3��9cΘ3�9c��֞1g��w�;���xg�3�m����3��=c�����l���ܼ���~?�a�����}X���\�kp��5���:\��p��u���:\�pn��7�܀pn�M�	7�&܄�pn�M���܂[pn�-���6܆�pn�m���6܆;p���w�܁;p���>����>����.܅�p.N�pS��2\��w�+�]9��qW��rܕ�w�+�]9��qW��rܕ�w�+�]9��qW��rܕ�w�+�]9��qW��rܕ�w�+��*�Mla;؇���n�X�	7�&܄�pn�-���܂[pn�-���6܆�pn�m���܁;p���w�܁��>����>����>�w�.܅�p��]�wύ�kX�6��'�m�`vo���5�c�X���\��p��u���:\��pn��7�������a����[�:6����pn�M���܂[pn�-���6܆�pn�m���6܆;p���w�܁;p���>����>����U���a���&����Þ��ְ�lb���>,\�kp�wW�mb���>��~wukX��u���:\��pn��7�܀pn�M�	7�&܄�p��z��a����[�:6��-,܂[pn�m���6܆�pn�m�w�܁;p���w�>����>����>��wW��a�����}���~?�a�����}X���\�kp��5���:\��p��u���:\�pn��7�܀pn�M�	7�&����CC<b�����'�H��b�X)V��f�YiV��f�YiV��f�YV��aeXV�O����&�x�����N�+����c屲�,+�ʲ��,+�ʲ��,*��F8DE41�#X1V�c�X1V�c�X1V�g�YqV�g�YqV�g�Y	V��`%X	V��`%X	V�o�����G�DI���`�X)V��b�X)V��b�X)V��f�YiV��f�YiV��feXV�v�CI���X�n�`+����c�r�������'�H��&XYV���#�"�"���+Ɗ�b�+Ɗ�b�+Ɗ��8+w��!�"�����p��`%X	V��`%XIV��d%YIV�v�CC<b��݃N�+�J�R�+�J�Ҭ4+�J�Ҭ4+�J�2�+�ʰ2�+�ʰr�;��=�DI���<V��eeYYV��eeYYV��E��~�N�DM�V�c�X1V�c�X1V�c�YqV�g�YqV�g�YqV��`%X	V��`�n�}����p"�$�`%YIV��b�X)V��b�X)V��b�XiV��f�YiV��f�YiV��aeXV��aeXV��a�nw�yw�#�"�"���,+�ʲ��,+�ʲ��,+���~�N�DM�V�c�X1V�c�X1V�c�YqV�g�YqV�g����}X���9�DI���+�J���$+�J���$+�J�R�+�J�R�+�J�R�+�J�Ҭ4+��}(��!����x0 �ʽ}\DC<b�{��`�A|��PDC<b�{��`�A���,+�ʲ�����Mt1�Klq�'�g�z���g�z���w�U�q�{�4��S,���s�B�P/��B�P/��B�P/�K����b�%�8���sMT��+�J�R��+�J�V��k�Z�V��k�Z�V���F�Qo��F�Q>>q�{@]1�[T���[�V�Uo�[�V�Uo�[��=|�~�9�b�%�8����T��3�L=S��3�L=S��s�\=W��s�\=W��s�B�{>���S,�����=�z��={L��G|��|�&��^�W�z�^�W�z�^������c�-���%�3�DCTo��F�Qo�{�=����!�Xb�#~]|ĸ�}� ��b�)���_/���Y��.��b�-����o.�=/��.��b�-���d��%��
�DCL��GT���B�P/��B�P/��B�T/�K�R�����%�8�����DCT��+�J�R��k�Z�V��k�Z�V��k�Z�Qo��F�Q�{~���G|��sD��b�)���{�=��z�ު��z�ު��z�޲w�ۑߝ��t1�Klq�'.y�������c�)���O\�{~H�s�\=W��s�\=W/���_��_�DM�|�&�|�ł_d�?���6���NC�K�o5���^C���O��EI���X H[�i���q��!�Xb�#>�����I�����ϟ?�_���      �   -
  x��Z[r�:�FV�D�$EQR�,;qƱo�F�J��T� �`��$��;�:����*��$�� �����ɵ�`�N�"�d^U���_e�X\U�/���L[c�bSW/���s����T���:�J$pQ�b��{Z�b��D���eI�xY^8�v��D$����:A�z�����^�������֙Tt�*����ƸD���X;��B;~��.H!�,�~�(�����\[-��F_�*�<_��PE�f�A,�(�Y����e;f�c1Ӡ:^�����I��y�11d��4�6�34Z�=�S�jj�dZ'xA����/�Z�'��� � S�D��~ܥ�^�bV���/u:�:��u��������������b����qu�n'pf���er�j��ݚ]�;o�� ��n�����6�Y&�6�Ic��9��ћzΉ�l��GyNr��d�ײH~�0�Al^�����o��B'��*�(�dR��L���FLMX*���I?�ݫ�Y��f�	<'�!�̲���p��`j��{��}��'�<�A�lfB�`�3m���~��Կ@cr:	��Qd�曵�K^��8A����߃����	�K��̪R�2
��¨�J�L8��R	]��K�
œJ��{����:	L���M�1m�`�1�~dkq�mF��ۡ����;Yg)����u�0ۘ-��_Z����s]w�����G���ڊ�9�n�X3◶%����u�JF?���²��[lY���m&�Y|`�%��-�����`/ƒ��9�,�lH�Y�B��&��D��R�-�94�P*u�������L���,%~�'�ڧG��ɉФX�	�G���<眎+�*��𙸂g�r���7���7� ��ZDd�r:�Eev�%��-�5�m�\�@���Β�%S:�5��2�!���d�ُ�����+}g,�=0�(�H�	W�m�'�j�9�i�@0���B�`9�k@�s�Z�G�����q��f�F^�g� �;���HՅT&�	��6�	f?���EP�c�3��lA@߄�e\�3���h�M�F��HkVY�B�;� �aw�o�/�Ԕ�s�j�l?�ɋ�7���g7�!,�O����/k=��?�<���s�� ��g��~���Ti��Z�8�g����Ʊ�z�u�Q����-W�Eƽ�1N�фx0�Rt)+��	j'�( OۻgY��/-(r��>�1����Q?���n�U�{�[ul�3�G�.�6�j	]˦{��v������ӽ��3����M���_��5l�	}�I�4���UR�5�6�r�9�:�`�����dڠ���R��$�g��jΛ�FZn;{�n@�Ԫ�7r�DApm l��6���	D�BB��"�Y-�e��B�+��&꿅Z-"��.Ȼ]P�A6H$�@=���1�����K<�UBOf\ɂ�3��#<w"�䖁4�#�*8I��E�5�������1���~�F$5H�k���<���DZ��WW��Y*U皛��h���Nd��eCxA�;�š��r^@�f��N^���̍�b��rl�I��9�-G�!y�58�Z�%�֌dxт����e�	�h_�������}�9H��Rw��']�����83�5��*�s<�  ��P�P'�>y��W1��]��j.W� �핁鎫� Qsހ�I�}O�8{�0 �d6}5��%�%}�oLU$���>)��)��MӬ�E%X�����7+����L�!�"}4���4dEA�| Ao�dN&��E>ز�Ɉ)�ߚ�qD�1��p�'a�����<���%�x��3�"5��X	Uղ�!`�ަm�yZ�J�ek���34�b!W�bM�����k�>tŎ]�A6��BO����/�Xc]���h���4d?�W���x��9�}PjbV4�����B7��}r�l�o�l��~�D@���lK��K�^�׼N�f���Sa�}��Tԋ�9��lz�h�Y/_ �/[ԿG&X�D"3�xh���&��E�p���Ya���DV�o���h4����?�S��^�<��~c��th&��-�ݘ߄ɿ�Ċo��0�����٥)0L��f!�ݸ?�T$��ދ��n��xRMS��̣4����qΟBLĖ}�'�Yƿ�rsq����w�(�)=zr�H��I7�Ė��
���aA�+{����5�V��.ИO�%\@�Pߌ��Zn�0�o����� w5�*vFl&����0�$�o)��OFr��v(&rr�d`�}p�)C}6�9���"��k��tJ^��1�m6�ѹ��*�E�}4T�M�|�p{U4����($�RV%�,&mc�wm�8��Q=��Q�t�$�Fk�f*�G��#[�F0^�$���l��ޜG��"��{�Xc9|��d��.�����>rgSDFW�+��N�\ڱ���r�f���ٝ\D�A���%��:��|c�*�xs�S�}�~��ˣ�*1�(�QxQ�����ם#C2���a__���c����nԾy�^��8�����i���	p���϶?���ջw��Gq�      �      x������ � �      �   X   x�3�4䴱Qp˩,O�TpJ,N���KU���trv���s�!��Y�RP\�id`d�k`�kd�``ielned�gaaal�i�Y����� ��      �   �   x�e��
�0�ϓ��	
��U���eK�6�%��>�Q��z�f��9�Q Q'�͘Bщ3T��H�,q�iB���
�@��-�oS�5J/�2�^ڿ�N��3Ň��_U�-*v����p#������b�����V�      �   e  x���˕]+D�t/{��X����k�o�$����sNi_���������?��s��j�m b-$�u 1Wܺ��B���A�3 F.��6(j4`qoM�V��P�y���%@��"�����.E"��e�"o� ���VTf/���3ڭ(�Ha�~��������yL)3��,cF��,v>�K&�O�*�<D���2VD�|3fޮUz>�RD=q7��K���rw���O�.wD�֏ +k[2d��L�W��z���g �������j�s�Ħ�n���6�hv/�����`B?����hS�{ �W)5��(��)��D!�S��!!;�0+�8#
y�d�(�-� ����+5�p#j� -*�OB��gB�C4t�� �Ӷ��D]9�� =��_92I�Zg���ф����B�-��ZUh�U�#��:p�Ѡ sf�j�Q|�� Ye�N$Z�B0x�����6�W!t��!cξΐ��$_�BL�1�F�ùR<{#"�f��}�!�%��B�/�{P�N��Iғ#����i	�sD['�!�������|3���ZW"�C5#@���r��4H�nF���7�����)�s*ܖFr��d�y��l*�T��#��RIv�dg��)kd�׌RQ�e��$���2P�қ\|{�r���C̤�>gB����ȃBH���Cu+$�},X�-d(�i�Cn�D��Q�ݿe-dr�b�#B�}�F��y1`�W)��}z�h5W� w�z�3_��>#��@���~�9�n�e	����K�:!�J�h�}�f�mrQ����ʧ�4�Z�٣Z��Dr(�^��d�_��5��m"٧��K&�U�[�v�9������j�慎�̡�#�T�;V`��?�#����k�ڐ^oT�jr��ܹ"Q[��o���o6p|M$ߚo9�j:Z�pX���(� �6���9.V����o]C��Z#`o���Z58|��	�s,"ā�]r�y��ww��62"�/���|O,�;%��w���DIS.��H(y�[�Di�\x{Drɻ9��HgY�n��x�52�r�*����Y���zSJ��@!̓H������<��<�.�$ژ��t�`0[""�F���'C�'���6�li��w�-7w�iٽR����p�37��7�>Y�Ε��f���V�y�L${�iP�6��0\��	�`�I�|#�	1��h_�:
rs|����I��u$k�A�����'���ۛ�˻�L�����L$�i�:HM�{h 8�{ϯ�̫8O���©�X l�[d�cE��[�&���y�,k��`ph/� ��t"��(
�-w���N^
�r�gD�n���荐e3��Q*��|p*N��mN._tG��Zo.Y�
}s��r�TN�H-)]$�o�r��!�{
.�B� 9A犭�́����W�Z>��˓�$7�� �(6�/Ć��Z�ɾe�wb��G"�;|4�R�s1VU�гg������\.�4�g[���@:��D��āb�4_����!(T醿����!_v��O��ˬHX:߂�jPPd��ń(d3m�����ɀ�(���xiJ^�KC�
����+ �O��Om�X8So�1z�G�`�v8k�˷g����H�c����[(*"zm��0O(��SIf���f#���\��o'Qs��m�qr5ÒfN����!W�3�GB93�7��-@R��O��S���<F1ސ-C�W������2\LG9j˱���ɹ��ȃ�`�o�2���f�q7O�6�(��M�G����&�8(�<H;�S ������p�[W	ɑK����:n2��\��_8���(��r�}����36$gn�
͆�!ȼu��P���*�5�\���
��Y�c�˦��\G�B�0��4H������-�[s����L��p��&W	-kN{盔��e�&��Wn�h��#�<<3ǣB�|�F��Yq��D�7�\J���N4TE�ȱ� + &����qɕ��GAX��P�%��ʁG"Z�y�r:=ϙ� ��7�5�C�-m�O^��G6dnG[����9�l�:��Zg�5Μ3e�9�b�9������Y��e�!:CjN#�-{�ަ�^p�~}%/x��+�>5�)��sB\��(+�XMg���p�&M�ؒ�]B�߂�R�n�)s�f6Kg�}�0���������r6~�.|��む��""��!�R���c�W�Bl����"x��D��hԚ��o��n���dd��\0\m.5>��V/��f���O�H���*����:療,pf�;Ann6�7��	Q�����?a�/��D.�#�@@���B��k��
Y�F�� /bI��Z�Y�J�n9مW�>z��!I��g�er�eUz�I���n��Z�&� 9�^����3�GW)J�Br��i�eȗ�25�m�O.���iDVH:����lܱ��}a;zy:�J̳����F_[�\�7�2,'�yk�*!�����|	r`5�X穹��?��lvu��N���+�@��$�*��sG"�(f?��ك����t�b
�$�ckX�w.'�9-d�xW��l�D3$��,�ȟ׸LE��\�]��&A[.B�Q	�J͕K���S�2�n��͡� '7��F�!��ͫfdI��7Y8�aH��hQ`m��p���lG�/ː׫d4��k�Tӣ��'�YR�_��U�u0�_+>a���;ʘ�
1s�'<(��iDV�߅ʎ�yu�^�N��U��=:��bq�',��i�u�K��7{��Xp�?�0$�ͅ���$!�K�?.��rss֋?r�9���n�{�N��eY���]®8r����7�@.#�����B�� �^9�5a]�{q;����ر!p��I䉣�d2�����`L������,�4�=���~IK�I	>`��Q�2
js1q{J7+l҃ �M�f�(ȥ@!`�h;����5"����i�#Z�E��t-�����D>D)K��*����OA��z�������}��l�e>�&p�z0�3*[�|�$��[[�ܻqpqS7輇��;���=�����'1�$G�Z(4Џ?�����xz�h@�^?�D{� �qmA��F���w����
��      �      x�E�וc9��`�Л\6�8U�z?ft��� _��V�~���i������-:ִ�]p�g|��N��Ϙ#F�����?�������Y��Q?;@��ð��;b���T������sJ�=�g����sz���K�1>���$֊Mb��b��PVl2\��_����$�^.�16��7/2��-6��1=Ċ��v�d)\dB����M���Wo�����C�������=u������cǄ��+.� ��8���}_�aن��?:.���4ȁ#Z���y������8}-�s�y�	�v@��o�!�
P��4�aP���͞I
�9zƆ��;���PN����{�тjUQ�n�V=,l��N�����2�� ��fܻ���B1n/�j5�J�q�P�W�^:��"��rD�K��,ؾS`SMI6����Ő�����:��Ɇ�ך�^�p��������ّ��0�Zw?d��2P�@k Fhs��D�M�(>�~�sK�`M�|��9�~�lp�U؅����04��
�N�P@-S9:�`ϦP�!�z�ۂ�K�+j�(Ŀ�2�����6��>dn�l ��q]�9+�@PХz��Ѐ0cP7� �P�� )˖���рa��k�	�"�YZL��eh57�[�B]�+Դ�����oW�\��IH(=� .7�?x^�LL/�@S~����>��BB豱��%@��͢E�p�:��V���ˆdje�s_S_^,$���S�	����Śq��N�]���������A��rdA���r��*Wc���:7r����4L?*������4@�#�B��F�֒,�&��i^!�S	ЧQ˵����}��o��1��\!��Q�=Ђ�7�XP#@��F���"���`�m*R#�.�]�w�!�s�?]�=4&�D�ӏ3�ū�4�nxH�9�@���]�ǳ��=A83WƆBA�����@����!~2����]���]B���ܡ{�e�cI� ���>�X�B?�2�!b���#i��{�,6Tԁ2d`X��&[�^�#bD�g�uBm1�+F��]vd�{ ��<I���IC�C`_D�<e=�o�D�{ �q�a��yO6\,�b� ���꘍@]��Yb�}��fӶ���/�n��A>B�����j�e/�\�0XHUlDN�on�"�l^�w�!�MX�:��e	ЏK"k�2�!�M�z�b��^-�VG݆���8ZjUBB�����@m�C�n��Jlۚ�_���#QnF�9�Ǻ2}]��tD��KiJ���4~�`�@�@s���.�?	�聍Db؃:���hز�:�.�\ l�0I��Z�����yv=f��%��� J�I0��L���;v�' "ڛc	W�M�`=�A[����C��Ns�l�D�� #W\���
�}fd;��@nH�����扦>�)S��0���(b����p�q��}vz�X=��]΋}�A!:��k���uD�T�� �1�
@�����M��ix� �z���MY�j�m4�zy�t�"�@�/mfI-��ڋP�&��X0�4]��dB�HRaq�6pl.�t��|��4�A2e�c�#��=*�L���"�r�p!iG�	��� �
�Iȅ�
�9�A�r���� ���`�7���V�H�mc��~�&�%9���AY�mcbD�&-����bn�"V�U4�=���1����B�ZC����k�=��@� [U'���l�Q��)�����,����K^��
�+��������x�(tM�Hs"`5WBɍW���&��6lƖc�F
���پzj�`x#w�i*�4mU6��I�@y�f!ԭ�y�cX�=���c��{;C��ӱ���As�P<��,���-N8��tې#�>XA�̳�f�Ń⒱@}�-Q����	�D�%w:�����lTtc�M�d��1 �JLGe���!#6�H�!�c�1/y��1�C~�.�:,�$9Ԅ0$L$a�����I�t��ol�����r(�X�P�3�Kce���	zK�sZ����,�0�BӴ� ��1���@$��r���� ���5@���]�����!D�j!�Ml ��T�08t�I\_N��9?����W���f��[̸�)8s�tKF&#��>��P�aB��;}$@9��g9J�Ψ�\��AX��Pu�n�K����m��v��!9��`6c��������8�*S�Q��t��m�	0j@j.$$��y�ai��N�Q�%�|��&�;P�F��D��Vn�$.q��_�ҒΠ�3i�|���t�� �)�`�I�'9Y�U�c��ې%�	M1}��(���/�!��*ݑ%Kn�y���
�6�b��7�f	l��?�ʢelc�����$�6ҡ%\����䜋鶟�|%�0랠����a��'��u��4-������޷vٿ}�P���QWΫ��,�R��ͣG{����(���Z�H�քY�Nk��e�a´�[�������O�(n���S��2.�-`W�C�~t#�k=x�,U���(	��,�������E�r��1h�r�L7gv[}.��EH�w�wd�*_r�վ� u�!�uso���V�ˡ�M�J��mfͻ��T�hY>�֝KZA�1���z!Z��?o�n��1�֗p���B.�(%��(��V��������'���Z�vc*x�*6�웫ό������B�w^s���:�l&��� � g�8�j'l:W4�u�|w�Z�*��aS���-"[��`
���V�+���b���ہ�Aqx�׃=������w���3�H���ߤcLT�W[m�^ֳ��S��B׌6�i�eDd�L�R�������ڬ��l3B�H�A5�Z��x4��u��2Ӳb���"(ŀ�j�q�I��i��N��OrOt�jKӑ�i���������<��V<�2��|�q�)3!o>��ߍ����~��=φa>J���|=���z�tnv_M;��\�nQҘH��DYG��l���]!��ז�[�L��6��$�D�z]��Jh*ځ@;��q*9]E(Mx�4��#��ўӻ�1�p����ݥ��z_����WZK)[��)	I�-w��XX˽��0["���mK��3�n��5=\G�v�(���o�1�<�VE�IMxo2xi�Gv�XGIo3�*:FO��V���!"�"��\��~��j�6���&��4�"�xKuѰ��P��WS�N�K7(���q}���3I�k�d'%H0c%�頬���9���W�a /�Ȟ�6<�!�b��`�D�O&չ��97S	�rvO=�,ʩ �+�Pf��E���R��>,�Ґ��O�V��{�E���w�m�c�{ ���K� 7>��R�^�/�,#�15xM�4�>��:`۔��iS�
���Є�!'���kɀ��#!�d

�2����/�<�N�`���Sc�T��	z�-P�e�'Ckޢ�ق�4n K"B_�D=��RB٢;}^u���B���u��%w�$�lU��i��%P���ě�xH��ֵ|?�OXv�H�л��=�>�{��S4�����D�E��͉�)���i��9.�hʍ���a�c0�&���#�x�O���B��z2�aU� 3�V�D-�(_��g��>����Z�nI���e=.��Iff�~e�����4�oI���&c
KݹlPB#H�����akN�Q��ukz��%3
�%�{J�xP�K��1@�[O��^����W�l�{u)V̧�OL�����;g�%��4�~ea�PH��_�� ���������B$GG�}���x5(l�1󣶁�+d�iٙP��%�F!̽zJ�������c)ʿ��b�J]����%L|��D[���ݺ�
B�K8��4������
F������f�hmŝD��'h��図U_����R{F�S���+3H>Ѻ㍃$S�5xߢ����h���P��D+��;G~*.!C��_���1R0��'��፛S�n��B   VRl��i��y��Ԅ��p�_w>��H���A�����_�Tk+U����b��5åm+���D���,zu�J���_)��-Y@�������n��W�����D��5Ŏh$#3�.��~���_������^oɯ̈́>�Q����@�3'��p�w��y�O�"�짾�~K�2Jan�6��f�*��i���v�ӮQ\ɔ���&<�l?��c�$ًҦ㥈�n�,q']0a�lW5�f�ȧ��<��EaU��~zZ��)�"5#���1������6"�S8��S����ʘ᧞��A�#��ӌX5�4D�AsK�@gfoU���k�fd��f�E�Y����	���T)2E�o#O t�ȏ�F��"�F~�h��3?���Tu�&�03��YA[E�����������ڲ-CM�2�S\N���9���]�(�X��>[�!"<W��u���w��k�U��p|>a��"�8�e����0D������������������q      �   P  x����r�HD�U_Q? !�Sb���a��=36m��h����V��ݤ�>Sݭ��ne����4���˸*�X���Yg�M�܆ؤV}��Zmտ��57�a��q�.�7�~�V����xu��+sq���O��0O�KA�܏˴ܘ�q~۔X���p���e�w|��^^��M���p�Ӷ�u�����.�����%.���j͛i����a��Bm�ގ�l��Lg�쩴�4�i;��t�ﴵV����C�
�V�N���`�{�R˫�ot�O�=���|\�����ԇ��Os���Mü�՛a�ͯ��t��+I����;�W;^�S��6��yG�W�I��d��������������lK��K��[�;V����Y�+{��t�ոn�v@֙�A���W��ze�t�ZA}	ϱ�ɷ��jx���^���q�%�G�Gwܣ�!o��bN��=�����x�Í^���f5��PO)1Ö+����=�FD���&���@-�꽷�M>MÒq���3��.�����{����]Pn=������4�vi��)�==~��]���Q����h$���ǧ�}z�4:����S���A��^��Ҍ/}u�/�F{�g�[ء_>��2}/���A�����|s:P�8c�"�[���v�s���6� �Mq�)�F$���7��M:JpS��Fb����縑�m��7�n�춍��%�p[ء�n�'��"���I���n�pf�N�%�p[d��:	p�8Ǎ�A'	n�s��nu����㸑�6�N���7��v���8Ǎ춽�$�)�p;d�kt'�]���z��x�p;d����.q��!��ӽ w�3������K��Fv��{	n�s��nu/�u�p�Ho��$^�8�uT� /y�)�z*I��<��価� {�3����& _�-���RI ��x�T��J�5���S���乻�9x��T��/y	���V��G�{2�J��<���d���/y��`+_�|rA�2�JV��g�,��[ ����l��5��d| �� |�3��`��V�<��`��V�<2>���ͭ������o5��#�,Y�j��G�2X2��<����p5ϗVX"�%;\��!."�c��J ������d�d��y>"�#,Y�j��G�G2X���<7v2X�ȕ<��"2>���M��9xd|$�%�\�s���HKv��g�2>���e���Kd�d�+y>�%d|*�K�c)y>!�,��j��O��DK�������lt5��#�,Y�J��t	��FKv�������,u5��#�,��j����,Y�j���`���u���\k�w�\6      �      x�3�tt����2�v����� +��      �   5  x���I��@��L19,A�b(D���0J��4������i߮�۳:�;���O�L��؄{
Y����f�����-��:}���i�;�����}��t�Al��^�*9ֽg�Uj ���{��^�2[ù�K�HqG	y�� ���(h�%�
o&���E�������X���q~���$��V]�[��z�\�ۛfG�
�HgoI%�!�|-���^��0�KT�!u�C4{��_�J@;�G��U��e�M�ql쫟��YTxcӒϫ"���h㰚|N�)�˜;ixǉƳF�.|x�g��Qse��a`��8N5P%�!7��o����8�a���yxq6��6�6�6L~��d.
dh�����&|T��$_��/s\����'�����)2��d�zܼ�"�mݳY�F�u1V_�'|�}�p0c�^@�i>��F[��ς�����5��㼸��Æ��~�ӡ����:��)iO�.�s���!�"r��W�M��ҋn�����wB����Jf@c=�zN��d�)h�*�*t��v|
��?�Τ9�̦��_���      �      x�Ľۖ�F�6z�~
��,��=j��M��dI��i��֞+,	�"6 V���c��~�������8d�dUF�<c�?�v�A"���p����QQ���S�iڏ���?n�������?��g?�od�n�,JB-��?�Dq���3J�sQ>��l��*俾��T�w*���d���IX8�,TX�$��E;�(�������=�	�E�a#��H�5#��ml����=�����&����w!�骅�,��f�_�9$�����X���P���a��]pq�t�F��w�\U���	��H��NY���~.�Hf6��@��_Y��W9�vD�b����L��M34*J��w@H5!����N�2ɝ/BL������oV���&8�q�4�� �*�#�%�"wɐ��z�ߵ]p	����}������1����1%�����]�����V^LAFI��.F1����a54���৵�Ռ��<!#�8Ϝ'*'����|�A����yn�꾶�8CCviZ8�fA�J�_�a��7w�������Zu��q�-��j�1%)nUX�$��.��~���Q��c�n6*40��v��Bە�J���(\�>��ö�/;��c�|��)��=Y����&�M�6�)�ҍu�RQb�o�������뺧0z=J��	Y���s�MC�2���=T�K?L����ZDZ���H�4]�5}�B$���_o�����l�F� .��'b~`�tM�S��݁�_�V��k�-��	@v��A�M�9�q�d���!�<����桚�~04��wi��r�t�m jb��&�+�y����[߃k�H���])_q���Qt�Iָtʚ���$�d޵�T�6�Ȭ�5`�c��@&Тt>��ٗ�>x���̭O纩�ȣ�!���t��ωq��kX7��zX5h�Z_�o��o���+�B�FY8UT�B�������m;M�&x�NA�>97��Z���𱪮����Z���H}�N[�d�"���Vc����*EH���ƞ��JK�zr��cG��Y�)��<
ӯ*��("�9�Zٗuw��a����ت�VV�#L�j�1��r�-�6�w ,���&���3�v�j�훙J�"w̈�f�~��T��h���L��gӜX��x.[Tb��3 �����F�ӀJ�k�^��è�6y�q�D+7�С#�;�2�R��f$c(��5�h�`{�A
�L��M�S:=�"t~�D��쭂�Ͳ[��d�_׫je@��w���=L��%g	Bu��w����/ Dl�t��U׀����D7P�;��E�����ܰ?f��.�c3�}��c��X��5���N����ݟ�h��6n�[�V1N���n5�`Q�#�x����0����>�k���!8S�@t#���0dU�m&���f&Q��6޷t�J�<���,�oj��/��'З��ߏ��]p�{��f�����
�{�b��)�#��B�����y���ր�Z�5Q��%��Y�p�������T�%_�;�w��j���L���%AE��1��c�;8f�J�	���e��IR�C�	�H�u��o\�[^`wӯ�KԎK��N~�8���� mx�4SӁ
�U�]��T�p����3����rٌ������qF���|�����l\L�Z�~c �y1;����#�5!�Lۓv��� D��hG���G.�kjb�k���B�^�bHfs*t{�����W��]�n������px�W8t�0VbI�>��^�w�
�����Zi�=�p��瞧>mN"�rWߴ]#��-���|M��H�1��]R��M�B���3uH��b
}��YAN�B������8]=�v>H s1��g8f6!\Dp��Jw�ב��]��r	s��H�\5�䚣��]4M��֐;�2�X��o��j�n�òD5"������(1N��M?N���VS�����S�艖�G�T]vuy��+ɫ+�� �/ƑL�U⋜�L��'P��p�V;*�$[Y"��V��/���n�/?�_б� �U��9�y�Iu�&

����iá����]�5٭~.w`yd�Y/~��� u��������|/0����X_��GC�lI��
cZ�<���q���>N�8��b
��"w|=bN�z�O�]#Ƌ�*����;�3��cwo[����XJ���p[�Ux�,�H�	��e��^�r�
L� L��s}�z��:�����jB�=�~�����%H�U�n�x�&ѐ$�?��넬�?O��&|S����D%_��'fL�2}�
���-
gį`.���;��/ rm����һĭ)�k���È�Y� ���-�U]k�=cr�!@]�幹l��:s9*�S�Z
����~�?o�>b���^���	�o�sG�2w����%�^l�v�v�(Y�[�=�qaSĝ�d�wy�y������cH�py=Ax�Ӈ��	�����.xQo�u?tm-=��X&�i�6Oa|���@5	�ꮛj���G-!��N�t@���X$�8=a|��ٵ��ARFGՀ@��+i�:�d������e�X�������dUk�7��#�#Z��fFF "e6?b��_S�N���S��Z�d=Ɛ�����#�b���:���6�����9�=~W�O�p�(�bUB;�!��=�:����7��<�ԟ!c�����p�`��f���{U�Kڵ�9�C����}}�pG��_��3O�,e��c��}[W����ai����$�5b~�cLR���1K���9m�̞
H�#G�s�����S;3�Mw��2�̻�sS#W���xҺ��˅^�m)Y���_�$�U�^�	`���"�r�[�cb_�؅�h�?����, %���d���5��r�|H�xNO�~��;���;�,��y�CTz�+?P���w��C}����r��]�[� �~Əd~��'�D�%V?/����;��0t�m�g��� *��1����6҂�_����=�__ک$�t2h*�z�nm�i�P�����Ɠt��>n�e��z��2[1:\W{��~.x �눭H��O|�%+Ջ~�
�Ǡ�^��H��tg������6B��ђ@���a�U#V����3D�N���ؓ��Cxm�U�i�ׁ�fm2¹�O��OT�	PHr��'��ݹ5RWS�<o���RJ��������n֟C�����F�XW�E��Uݮ���t��!�䮄.�' 6�c�K_y��@S��a��>���4��#���2�
d�Z-L�^���6�(=����վ!r���S�R��"W����4b���v���#w�52vm��M<��}��+�d��N�66�K��y ��~ӈ7ͦy�?� ����VNC&���AݴS���\��j����H�"�sN��b����1'E�N�F����qO�� �� dF�HU�t��lB>�F.e�y�#8��v�El_7�ٛ ��i���=��3�&��|�k���h�U?�`?��9�T�&��g��S�gSaR�����X��o��W-%.V�ç8��t��F,Ё���߃�-�Y���W�����'0�zt�N�Q�aN?+_b�C��7�S�_*�>p���#4
3,ԋ��ҁ]�nX1��.��W�%�R��b;��TG�3%$eX�:��j_�c�j� ���[!�x$���V��a�n��E��e�lv��b"(!��G��8����;��Vll��l�����^�#*�I�H��wGb���%����M'��+ T?�e�����w1_���Z48v�������&�F�����$�Ѱ·��	L n�c�Ļ-��H�)n }=��X�!�\��y )�r��́��(����C�0Q��ʿ1 {e�L���gd3�¤�1�|�/@��~�t�Cf��PW"��5�[�/�X���~�t�\d�t!Ω�\�������M}�G`?�&[���Sw�uht]�?��X�6�o[��8R9~U�HF�Ř� k�-�I��R�ϑJ���76z|?pv�ІW��P/ūlD��7����S���]�����    �!�Axăy�<oud�`ZS/7���"���>F>���g�2�v�.�6`�~�?�*�����}��cu��bV7�.9�0W`��{o���N6����gk�z�Ȧ-��15p�SEVf��;����a�,У^��h+=4`%��O��U�+�r�=��	.Ы�tρz�D:YY&@&���MU�'Ó�~�Wڮ����o�,��nO�0�(�h��7�*�P��79Zv�p%�{BCiĈԛ~��6á[I'w� b�3N�E=]pxA2��훶s��^#���zJg#�s{��$p���~G����b�[�mpV��/߆cc&���II����� <��@�FH5�[��i���0���V��H��ñlԣٙU�>�4�W���J,��n�S�gO�?��q��%F���8�1o�ym���Q���JǫcS��5�]���su���=5�b7�)\N\&)Ŷ����B�3 �V�;��i�\_�q�W2F���p|�"N���e��$�aB����~p�A;E��[����0|#��ݮ(h��ĳ{Ϩ��IuDg�O��]k1b��l��Ho��eU��\Y��� V�� ��xG8hɨ�x4ûS܎�:��]���+�@����2q>S�X[����I�s9Gp�Y���Bd�ŖBBDm+� ��:�mL�F���z��٧�^=�~ ��'�
@R?���PO�_�	Q��
^�;�q7ݪ����NCdo�]H�h��lW�\�\X��vh�U��F�MRHOqr*�X�-�˾����1�Z�oDy�rX���@R
�����&1b��e�m��^ʱ7��7Md��ݑ�������MM��w�������zo�{����s�!�9I�|>����o��=��Ϟ��N���M/h�2W��4�ឨ��pӐ/mIo4]�1�D���;��4Up=���m�����!�R(39���rO�*�L��o&a?��F�y��VX?8F/>iY����H�S
�ek��8��Ga��tHW�NC��-m��Ru���쐧FڨլP`_�	�� e���8�*�ʾ1{����f=��ռo��\3-d6���"��C~�嵁�V|�UJ�Mԅ;�ؘ���B� ���Y}�;q���sx�g�r_qY;�[�������o��Ґ���AN$՘J��s�B��u�Gp����<V�+��K;R����[��������TB���W���I�X��6�:�v�8`x��j$��ѝ���]��)sxh����t�a�vibË�J�j��-r�����M#�Kǌ8^K���)��"_Mf?���Ԭs8�4�n2��||Kz��>�������e���];���}�:�wS�w���[��|��ͧ�$�����SnY�R}��͠K���s�G��)�c���q/@��CVa\MC�ȪTê�`BA�9����;�F�lk����XCp�/���2�E|�P�p>_-/%��`ι{�i/�������zI�/"��^*C���F����,���\� 8G*[���G���5f�A*��Q��J���c�xˬ ֵ�V9R�:�]�b+����ǳPH�݁_r/�Y��p(5v ��{�ҵ#9�zM.Sk�)o�X�!�_������a�F������k%�J	��V�f-
u9��CV$��dR��+��=�i�`��`]q��]��h.��d5[�8�\O���Ε����qe����Z.F�Bٴn�P�yC��xFa1���� n���52�.X�����>�yF��0��`ie`.�`����uV�Q� }l�;+�1�7q}�#����H+�Y�3�1�_L}�p�~�ᕨ�C@=eH܃=%:���r����'(�����Ԉ��];�p]cf[P3B0xf�.'��ok֙��F���h������I�ᕫ�ps����v��$��� îP������V�cc�(��>Qܻ�M�<�j��v��;�^�� �QVi�]?���ZG��Smw׎���	�4�_F��Ҹ�qB�#Ǌ"ߤ$-M�v�*��^Y��W���#��:OA[Ƒj��~Swb����!W_%rl��
�9���b���.g�f��7��5"���d�S��f����/�QB���њ����L���&�PF@T)h��<�X�o)Z�j��w���kݓ.��3�2H���1���EF�B�`��p7�;��
B��Pyz�7j�|K�Ͽ�?�T43V����c���%�	�*4�=��9N�h�@�M���^�/s��L��+��}��{��>��W?�ˡ��s]_!�갏]�>�Ķ�;I�i"�����sD�g�P�j��~�+���Z�C��MzM�p���G�B��0M�7r�=��;�"�0c�P�	����4d ��u��@�@~����>�sg�=� FK��CMaT���@R���5����vOA�TJOՙQP��w��s��؁��R�%���cJ�_n��0�n�&EL�����1�+��A�d�nD"�����e���d|�\�Si\�_�i5�g��?��D}��t��В���Lu��~��V��\�Z����U�����M�:����m��&�-���޾�o؅�Y�y���ӾYAdo3�7��˖��,�ș���W㧽�����c����{�E�W)ݛ�MKX��q����8���U/�I3�7�����\Z��������[���3d���S��A��u�����.�m�>�#	<E滄Oڎݥ������Ǹpj�0W&n�9�U�U��i�7?��+�7XU���_��rk�7�*@���c%���v�4��)۹~����t'd�g�b�j��pU����݊U�Hj���a]w�32�2����g�Ϥ�~�:a�0S�r'�b�,Wo�����<c�
ӼB����Ο;���1����4��	���n4�C1�ke�{0R#Q��A�Q���WC㜦{�x�9��r�����^��#���=�$s�6��\e֡z=`�i!��$W�=�i\�y�}�1R_�+L����&�Yj�>!se�[-��5��|�Nb*�e�H�����A3M���&x9�{1^��T8��n�"���3�Ȩ�$=}�\���y��̳��h�$�!���텹�[Q���b��.�z�v��k��""hgݓ�Ռ
uE�Ք�*��+t�CĆQiJ�]��b<?���̋c^��X>'��R>�{J(R�1T��U���A<m56M�n�`�	�{(��̰���$��X��`�Z�:N ��p��r#@�>:,�Йl�6�4�����e��v��m��=䞝���'ϊ-O:k�3i�A� s�r��iC�Q-Jvr�	#�Η�[$N�u�j��O.�3�|��[0�=O!�рص4ԣ\��e	n��1�+Ջz�U�}Gy�7�\W�$$��D��i��
L��� 	��h|���&g��Ќ�S�F����7zõ��l�F��8Y��"����RL��,d���c�>]j8��5�ݺ)Sh�!�܋yJ�aM_l��'�f���g�d9�f��sw�17Sjkx'��a��t�[0��X�����qv�x���#�4�X�M�Cc�v�!!���m�A���U���I��H�q.F�=�B����ZgA
��fm���j�m��Ǻ��6SG6ſ��	�W���_����TWx�v�p�L��m�by�x�Vk��ՄǍ�^�*_�y�m����n�yTm�'�P"��¸7V��Bן]��ic�%<<�dD���pMP���)��{�vd��ԋ�w��HsʆHG9v�b��]mJ�{\f/Z��F0����nۡ��|�4Z��ڠ�99f9b�3��RC�	�_$��;��ލ|Q�qmY�-k�9�ɘJ������f�NH��=����Š�t�:�'�)��6�~���S(�rb1#j*i�1R�g��4�J��0a�!�����Ͽ?L�=�5Nkj��84�	�/�4���xO����~Ѽ����=��{kG���J0���u�b}ܵTwmj�    �t��3'���U#>�	�B�ת��Zx
�x������-i���i�S�@:sLh�ɛ�����g�la�M�d~�cO��f�� ���z���vj��=���h��=A�y/r�u�y�}���-h�C���x�������������܋wR#!&"��6��mעv�"���LHI�c���yIdF�B��[���� ���i�>�S���lύ%״�]p�u�{[�JM�+�U#@�A��G8zJ�oy KU.p%�j'GG&�_bMc��=�4C�����F4!�������COD{a$8O[H�ïI[e��&3o80X'$���{����ךW�.�a��"�j�&PE���؟#�!w{��}3�!U������6tL�@Z� �#��� \d�g�I�>E��#>��-��Q�a��n8��H�D8]G:�ؗ`�2�Z�5����Í�г`L�+՛z��ʈw}/��ƀz���N�k{ƀf, �1��>�hE�p��JZ�|�rl�=D"7|C�f]݊�#��o��xG2�F�7��u���(�ȍD�DҾ�O[3�ؼ�xu��e~?�Rt��D�%��a��W�1�V�����(�US�u��Y�^`,�a~{�"���s����5�k!2�o�4����f��ݑ�`an�>ԯ�P��oB��qTǽ3)2��]'f�~A��S8l���M�����������Z�8���$�O�Ⱦ�����?��"Χ�hy�ԣ'M�~Et�6zj�1˂��)�8�>D!s�)zjw�]?�5?����XL�T���Ͷ�[oy�s�o�H�S�ܡ�����`㏈k�yՇ;9!pO���c�ㇱ�ڜ+�ԩ7_�����T�*��*�0×&�??Q�}����ժ]��!�����V�~
�/���LiK�s8Y8]:� ����B�&g�?�q�.��������2Yh�e)��SXhtj~/N{��֢��
��/!�kBV-��v��)�]qO)�Ѻ`�q9�+Ʌ��
�#��^OR�h�T�ͮD���ɂ��4n�w_jF�Fe&�خ��Yf�9'����n ��
�!�)�:4͕��r�?�Z�0�N�Csm-�w�A\�#�9}�[���s�^���8����N���&`u����P��E�����F�gA��An��/� IWi*ظ˙�7Q~y���<���t{0�9��'��޾�z����/���ә�������i���F�5�K�'ܰ^���G2w����a�����6|%��Q��ǈ��©�v���}��IZ܋=����}7�pb��T�%���pڄmH���4�j�J
2�ij�Eh�hul!��5Y�5}S(�w�P�c��Aq�)�Ơ@���G��=�FqƴSq>b��զS�!v�h2�#x�Ae:�����c%���j�Jp��
����vy0���NzԓA��/w?�B�as�a�^<�������.���P�d"?Eq��S�g4b��w��	^��T����L�f�Ю|�dN�v�3������	_�Q��]�\��nz�(�//s5���Be���n?92��j:,o�7F���a�$��#By�5��d��3�����HU�/f��q+�'��3��
f>�.�u>]�+?�3���˘� ��g��ᩴ����y�����' Dy�iY"����z��� ^DL��?�_L*���fd��-�q�S�V��J��x^C�t8[��j6��"̿~n�Vj$�L��9Gp��mE�F,Ů'�zΣ��&�z2��kq��S������QKW#�a+��PTMX��fV�X�lZx���+W?5�m��!��jH���?�p�>2���F��
�k&K��q��{�pl8b���eXĳt�Zu��T�(N�}��G�'Z��)K��� �/2��A���D>���	.S��:��_��>�R��KdF�K�7	�����=BI�n�G�E\l�)@�jF�q&�<v�.klh��4^2�	�*��l����b�\��@*��Y;~r[9��Z�=���O��d` T�Js%��X㋺�A�	|� 7����@2�i���J�e˫���U�/<yzͳ@ӫ��ݝ�#��� d��3��T������x���+�|��f���	�H.��:��y,C�^��}-'�L�+M��=w9~f8�o�qA�c T�W{B,G:�e�s���+nT�b�Ź91��c�(Qþ��DJ`��U>�Ri8r�z54b1�R��\5��D��k�>4=VXs6H�c����8��HY~��|C��ٛ����|v���p�b߉Ǻ�J}�L�3�l@�#�E7��t�Ec��B�F9����4S�,�KC�U/��T���X�3���}3�#T���t��-�vF�-�#�S��6�İ��<׬Q$/�8��sN�������K�HG{�L2�1yt��_y�e��l�H��]�n�k��6 ��4S�n�]gT������g�Ġ�d���'U�YJVF9y��.9Rl��YF_|�K\�+��z���Έ�2g�
�ˍ$FT�j/KeZy�☸��e36��F��"���t2��$�̋�����l����5�Z[K�O�����p���i�7hB��V����m�^�L�8,�cjY��;v��������o���Н���D}�Ɖ����<h�=8l�\6�.���T�{�S��ϰ=�D���b�[�����K���z�e�(n��:�⟶�m��sBg-鮶-�\}l�GTW{&��Lc�#�͐�,���^��u3`fB\,���Z���;�ѫ�ٿ�U�ꢣ�������J���}�{�ey\�z5�����UX�֧���#�*������|��qB����oi�.�v�r�Ej��-5�غv�Yp�n&�҂�H�����]�b��^��g�9x�ۑ����ms�N���/����~&��in�ά��p�@�q�ԣ�!�������$��I�<���a� ,s{�� �����=�03|3V	7u�n��!� &����S�̃[O{K�5T�o*�t�~C��(��������T��b͠=`|J�ml���{IU<�e�і�U	m��|�й�����'��o��s����w���`��8n+���[5�5�*�n�)4��S��7Q����E�պ�} �|{�֒&��8P�g��8幫U��0��}GE�qܑ�$���Q��� 6R�����g4�f���wT��CjX���;*2#C���Qa�~ֹ�[��wT��3(���
Cw�4b�����7:����r�xB�	�������6���@��+�{|Q��:�N�y��I�E���qO��v�6+y���������=%2L3EM��a.D$�e^l/?R���A�ߜ���N�g/�w�V�ҹ�1v�O�c�78Rʄ�C�[��D�O!��sw� 5b��
G?���R�9�L�3%��N�p�!ʴ ��g?>�x���\c#��u=�g�@n���뀻4���G 	C��!� ��n t��F�H}�VͰ�Y�Ì�c3�ܲ�7T��������fĩ@T��^��z.8���:<)d%a95�Y7�0"�B{��fl�JV���%�k&2ɷ�9��)���W�'����(L��L�'Z4�;$�K�cN3�� ?�x��Om���d҄t�r͎W��j�P�hC�ݔ8�odd��n5r���8b�0���#c���=L=6���@�خ��� ��0Gi����;��(�Z��c/�J���T���S��	2��&�l���"sŖ� l���� T/�]Xo�FR�!%�d�:���r�:R��������a������@����������!��&VW���~������g�6�=�ĚoV늼q�)�xq��o�*�Zf����҃��!�n������i|�`��w�60*�Q���=D�q'c��"�ҹ�3� 3w̪��A=�X
Ԉ5h�mUO�T1R���"-˂��<rzG��8kn�k���E*0����]Q�h����%��    @\�</[�s�z�(T��}�L�>n)!mW|u52��o���c'73_�K��Dy�A�u�+�<�?r�%V/���a��N���+�����ҹ��m\�;vkt+��Q�M��B�gw D0r�t.���ih�≺��q.��DE}Eq.�cW@x�.�(<;���Eϯڮ��mhH�5��s�v��Qu��m>t{&,a�U���j��u�g:}\wP��HB��!r���1��i���Eǳ�*2��7��+�>j���D�p��b�4]��3j�:F��FeT�/4>�p�̽�%1b���R̐-n�*�m)&(�ۧt��ݵ9)s����S����h?�D����*WiL�4����v�N�����v��{�8�u��bfJL���=o�[q4��6�!�|�eȍ��iI��d��J����pL���ҩ'1sQ��}|$��-_��Ε����Q����Ryf����r�=�t�\(����v$�;�	K�C ֥��kJ^�
�[�2!��5������"��Aaa����R��wH�=�����.��P}:�sF��`��~�����(��n����w�x�6�(���¾N���ň��r.�%�;��rvU�x��%wJ832$�}��ڱ�u�0D�>�t:]��? 7�SˎX)rŢA�aY&sO�{�xaXg�#<��?����t��i��4w���0�*�i�w�ine�,L V�lOQ����7LT(�m����W}��4�<���k@Ʌ	G��y����u@�8)��!�B\1�vҬ�3���T�%ا�����X�e�>���'���0t��Ći����-k�(�abĈϭ]�j���n��;R�=�?n�����.3���-Pi�������Ȑ-P��V�p;��ᘟY�B/̯�@Ϙ�Ұ.�S���I�f�2�ƾ"ͦ4����C7��6Hh4�黕c(Q�Y&qŶoyQ�P�cEne���`�v�Ȱ�,������m�<r��st���d�a���P��j��r��1��|�-.,���#�pGI5"���d���r�B�a����	��*C����L]����M�y�}G�u�VK��:�A8����R�?��9q��c;���K�69p`�-@a��䎽�Vvs�2vO(�R��q��.vL�{��ƉB��$�p>�n�#K$�~��i%G*�ǡgh�Qn�r?t�q/ۃ8�l��5���1Fזyj���G�LN�����p�[���..�|���>_���$Ɲ"h�����/�M-�<��D]��"���S��&
-�X�?	e23V��PsY9�pw�{M|b$��~]��� k���_���?�Y��ᛩ/Cp��LrA��A:��,�#�K�|�*��՛~
ރޕ�^m���@�
�|N��3w�cnX4�Un�f2lͮ����G5#�dq�e�޶K�V*��q�BkPv�����t$�$�
e3����Dc}��'2OYp��C%���r���մ�̱�?��j�*^��롧0:~���-42����o��%�	;GFA�
ARf���ݤ2$$C��~��|���cW� N���Aܪ�w��$4��n����C�;�}#Ć)&|k����˵p1�]dw�ybxe�%�Ł�7Z�U��F�2��\�԰�)���!|���^V�x��OSo@��L1��I�l�./Ɍl���郋�o�;�~��7A�U�;wKX,c�����Vu�d��To�p{5��Z/�	�������g������h���3�YƮʟ�t���}�E�������n�w�\;
�6G0w��U�v$�Z��V�B�=}�ߵr�qϣ=wb�Oq\N�1AF�H=��|ꥨ_�RMj�tb��w�Fц��8��X��G��V�z��S����+Q��ZL�@�g�����*2��inn�nU<�W.���@���c����Ql��NX����,e��NS�#�e��{F��\)2�B�x�.AN����-�n�b�<p1Zw8�	9�s+M����HR��8�M?����N=� B��������5q��1��'�Ӊ�y=�X�_�GK��#N��F�5t5��fH�`s�B�m8փ��-U�^o����ӛ��|0�wW+�\f�c��Q�C�5�q�B�Y&�k;�%�l5�+o<,�&�8دn�f�������`�z��ۑ��T�EF608�vl�ih+&�!Ӹ��m�ǆc��p5X@�M�F���'t��-^��^�7���$�i����c��N���f�1����~���D���N���4Ҷ��i3��=t.��wo�n$�{�dnx��]�C��C�Z {xh�r]�{�wa�F�w)g�w�������Ρ3YT�;DUb�����	Ǯ��
V��%Jݫ�Qq2�-&�&�Q�E��f4j,N�����x%/�0�l�TIN�2���Ԡ��&̩����(ç(:ډ{A@d��Z����?L�Y;�K0OkDR�c-�
,0*��Q�P�4�| �m=u"��A��'d.��m'֬K���mK3��l0 ���P�+/|ړ�&���ԌN[8��S�7#8&7!/&��s�Q2#d�[]�p<E��#4��뛮�ʸ�m��>-�)�a\e����"�6e�~��<�pۙg@�f��?FM��������èCu�o�O@�b�+\P-�4����<[���������k����߶7�<Mw��p���h�P�������$T�^MW�ğ���vBӸ
�}�F�c��tA�@V��  �|�ծ誗Z�@�Rp7!�F�R}8��v �>�;yH�a�ֈ��V�tA��q��-Fz܆�+��7�Yv$��:���XfB
,����\��X�E�{ T���O9Gpw�[KdF��1�e;�y�#�������X}������{�b|�����z��ۆck�]�_�������	W�=��5�[BV#"�kD
��O`���3�J#�����0H&���8��Hg�m�.wn���K���V�	K�DUc+�G
���>�ўi��t�0m�U�K���ms��"יd�3#�X��.>p�h��&�0��*�p�/o��Nn���B�L�a�؍�.���&2��� ����%��j�բ��-��Ww�],�;��c�b-U���ѱ�v�t�`o^��-�ӄÔVm���E�@/��
�f:�8w\j��j4n�N��@��2T���qd��z�͜����8���`�	�5p����~{g�v�X8?`I�2-?+��F�ma�R���;��\�d�ףil�m��c��n۽�u� �s�G*稽�r�7W����?v`�{�Q�Q�6�T�q���k��W�qj���v)��On���J�T.v��۶ ����b�x4�aؙl�[�28wi��^6x���j��b掱x����F�U+��p=kC�\!����V@�$���I�Κ]��5�������)tv�:j$U6w+�@:���1���$g�F���be���pK�W��v��by��i__DK�u:au��R��L���S���}��x;����)�.9+z����[Y�ꐭgǨ��m�W��iz'���HG���JH<s����H;Wrt�q�'dzS3���Ȱ��7�.�������u��=�:6LA?��z����V,�2 ���P�2pWR'�o�Y�[�^9F��!�"9!�W^�&4j�!o>lׇ���v�~>��F���j��jh��0V �z��d�7�*ry s���87�cm���������a�1�=YwOa��!��p�*"!�9#�+b&�Y���h5�����l3C;�M�c:�p��bd��d�V�O@m0�^�S:O p�XC��~�����k-.�PE��z��'Qz,D�"I��N����V���"��@�Fo�l�SgN�c�##O	�Jnd����_�vO?K�y�u�k@[�]/�����T����p%�o���X_%���������ӧr����M����WtxG�K��Ld��7]3��s0�W�~��M�	�� ��:;۞̾f��     ��Z���JܶB��L����[��zU��<;����^3��I�}�6����[i�ʨ!��_�v����O}�2c�� ���:�Ď�S�F�ml#Y�06����-ŮUV;r%�P����^E�d �������^�*� ����#��г��h��Tô���ZO��u�����7�P�\q�G4;+$p�:u��0
�U��/�pw��j�������@j!sc# �U�:��;M�������['�)�'᥋_�~�5b�>��7)���Aصr�Ԉ���4�A���(DA��qw>3��w�o�I��01�nFk_��E��c����M��?̍�/� ��W�ν�+!�h�O�+qJ#XA�Vh!�J��.[Q���r+͵Ģ�Nte�{)����n�%4��������[6$�^�C�3 �*$���|������^�{1+���v�ͫ���a
�|��E���v��(��=�������>�Ɱ5ݮ�QW��S�Fm �?��+�c�j�ř��ܣ�,%�.U/�|�ռE��u� ��s�w�Vdd �?����Ap�@�i�ΟƆQ���C����π@N��g��L�4�i�́��z�˭\��" ��/(��=F�s����P�`�,� ��44�~Q�W�'e�A�t�L��;� Z�zt���1�4Gi��cE��I�bj����P?��ȨjO(�f?�����#E��epNz���+�q :`�r� �(�/���
^�YK��3���g3^��5Q�M�5i�6@��<9!s���UVh�؃1��zj��8�dF����Yw�N�5��m����"��e��Q��K�̶�oͮ�pı���&�{`Bl��m�q?]�#L]ǰ�\�sBf�)��u�^�¯����g��R��	�Tm�nM5�x�#׃�=u�JZv}��U��}O�gq;���o5nB��h Y��g��{j�5�H}Ć�v	/�\a�g��Bu�@�#�- N/>�0^��C�D��{�d
����4��#<��vU���`�أ��n�J4��
u�D�x�;l�g'�1���s�T����9B�xC4,(�����'`�ŝ�m� ����{��&Qw�nh�N��p���"~D�)���2��<~~h�X\*,�ݺF�Y�2�ÆnS 4�+����MW����������3Z����0�n�١ڦ�90�����XG%����tn`���z��-|��6��[=����f������;}���|�ԗ+�����\���H�R��i�:Q��$x�3l�>�YR-5J���A���mX�b��C�}Ȁ�������B���l��rfX㞵�Vzn�feG�!S���0��+.��&��q馻��0��@��zǶÊ���5�4v��Ri�#��	��-eC�.\Ğ=+Z�R�F�n�*$K��]T��*�n�,]��؃�k@�W�y<����F�����+}�Z�P]��2�ѮP#@lW8RI�������x��HӇ�~ HÇ�T2�<�W�7�q�В���A$b癵�v��E�k�2����J�ݧ(64|C��X�����0s�5[�����v[�	%j�����ms#I��6�b�H%��7�Q�&ޡ[o�����/��Y���s���m���?�p��{�hid)���Q�~�"G�܇sJg��ݒ�&>�/�>2xK)����ّ�<]6��r��0���!kPs�>5ㄹ�N�r����6��|����?�8��I"��Z��Z��J�55<+��-Rv��IOwOWdD����7?(�#LI�B��L�c�~ֱ����_k1�Z�b�{���He��XO�D������JӅX�&r���e��)\FӴm�W��^zO��o0tࠡ��:3d�x��U-�BLrnLc7�ml�c�^�;�	ծ����О6m����w��#Dz�3���G��^���f�h����0Պ1v;��]��BT�$��+�p�O��~�T.�w��F��?��#pj�z��>�5��b%�4��1F����(�z������?p,�#�A��K	�3�6w�m-F��1��^��6Ǒ�b�,�����V%3L�L	�Q��xU������q����|8�F�B�.��4�L߅�# 6L��kWN�;~G�'����K?1|s*�h�,�@T�dC����>5�
�aM[(�ϵ_K�'��n=g���%���i�[�r��� @�sg*��c�0�b�6��jj���� `� *	��)��g�Vl��qvJx�2t,P΄�X����#@�.�=�mG�Rv}^��}t$�zό�3t�<%�q����I���VX���>����´�6��Dn�tGf��+��V��Ź��=���q�aS�/�gQ@�-�'�m��و"&��<8�ЃX��79�ǭ�nG��L�lW�5�b�C�U�C0rG-�Y,��.A�	�&���C��[T��Oq\;賓é�$V�>v��ѕ�B�@�6��E9C�ɍܵ���\�χ��ČBl}k��KAy�C���mƳ!��Ù5`4�k�2��+�p͠�B��c�.����@���)6q��EiO��g%Ia�' z����4�����t�""����G�{�\4���G8M�.d<ˑ�k�p�����,P��8�,��)�U3��f�JBi��	�<5�DW�T��)��;e�d�z��2�������pj�P6���v[K��'\h5���m�MGImCX����j�WeE[;��	��wkO1���8���"��>S'u �Z�q9�s|�}c�3�w8cF�k�N�?Z)���e�!�!:���4�`y�v�c���T Q8H�nAOq9�&f	�!85������枛���ʪ`G�Ԩgo�	�����F�T]f��x$+30���dz;Jߘz�;��F_� 4�ĳ`4���t��>�<X`�Z�� &�L9+����Q�@E�k��8w^o�̯�tl@��y?�Юn�?�[+Z��+�-�f�B����U �,��-�}��piG֟ն��k�T�a���r��*|)F�g5���.��yI��b���L��3�.v�Z�+S���P�h���8�T��*����4�ep1�� c�ӽ�ڪ�Ɂ#�_х���p��,�ߗ�]�[ً\��A�v��rq�������p֣aB�jp��<��\�#��Z]�&F�dǂ��ǀ�X	�������۝����2��n�ͼ3E�uJ"�ma7�(rNY"�*y����B�g9xz4�jԅ���$E��1�7���<{��)����x2�T��t_�+������y��CeG*gO�13.1l	���f"��n�,k��w�L��t�8e螘�	��z�oW�xc3���JxO�L��7�Ȱ��
���:�0q+�b+�o��p����rf��}\�������G�h�#��t�:���7�gI���i�1ɲ���fx�U,����U�5�S(�����_����xaM�;S��N1���AbD�b R�c��������ñZ2P*z��H�[���M}Wc�����l�*���Q'w�2�+�e�Y.�ұ��h	!j�2W������cߍ�_M�ĘNj�<��a' .��Ժj���|'\�h����!F�' 6�ܣ��Y���7�.s�-�.�f&��9�`�-8��_��"I����,f�"���V�ZXY��5��tz7=����>ƍQ=]��7��tc?�#F��yZte�=f����v�6�X^k�O,a�EǷ(��R�ys�vEN�e�����="���7�#\d$jN�[��bqF4���u�|͌s��b~�~-K��r��R�@��y��,A��x���v�8�����nW�Q}b�ЭB�Y��~2oAkd��O��d�3��������)�j�����W�5?6ѥh�e�]Б�lCr.0|J���_��Ɣ��t5��<Z>��O��o�[$ڋ��Bg�p'���YL���mA'Q�u Խ\��9���U��    �������������-fR��p]w�W_��kdaI0��� �)��B_������?��KRi<(��
+���ckV�8'irE�]?������˸OȺ�Գ ��.�6�!��Nnk�*�0�=`ĉ� ���l	J����
�\/�w�m�y���>�^�I�(�,b����`�vW��J�~���6��JO�+T���aq�$��Z��o�{�G6�ƶ�5�|����+��� �#�?h	��� ��Xmǻ�i�]%�L�g=�s/ct��DfQ0��]�G���MHW���!rw���%H�,�~i��F��X��Y+7�z֕	z
��v,��y������<-����d��bߟ�L}8kQ�g�ٴ���X�҅:�����Ǟ u'�;���@�@ǂ���x[�xf@��/B
�N ���j(.��m�^cB� ��]̯�#��Ùى�؛Ӯ:nt��Ъ�v�[�����q�Y�g��s.�&m[:��=���{n�=�YF�c���U���'�P���+U����_�����o�(Zs��߈fa��h�o��D�<%���e��jX2ڥ��Ȫ��Z�d�U��v��
�0BXl����nW���g����d���M�w�#��e0��C�0k�*��|lx��=��W�F:�3�;=	�Y%f<?���F�b�7���k�r��	�ĸ4��U��n�Q?P��%�؉�W���y�i_���{3��ܹ�x�R���QR@�- "��<�E�H��Y��A�v�%����J��I����Z��](����������z��s��(w9����qFR��V���1�EA�|��4���]Aeq�i�n�	�=��g��� Uo���%U(Wۦ��I�)q�Ԫ�B�q+բ>����n�8v��l��U/�0M=�X�@�7d֋�j�;��i�-4�͜��F�)#��OQ$P�A��%*N��h�
E���jöT/�m	Η�_��j�n���#���=x��b��X���>3�Ϟ��#�;���?�%ir����p<Q%5��DΛ��c�5Ro�}��W4Xw��M��ĩ�g � sG��YЏ���aX����d��ҹ�Jg��z���{@w9��Up)Y�����N�g�<ư��d�,�j�rM$
=�7�IS�#��,WW��Yn8�"T9�;�#�C��Ԇ7��'엽���#O��v��ž�{R�e�_�v$HOj1��/����l�^���v��ຠf�Ń*a9[�י,c�P/����/bi�
�՝]C���:��e�>�^�m.�5.ѳ��uB�׬%�n�A蚊��'����@c���Z�G��S�=dz���?ų��������-��nk�A=Ru(�ӡi'��9v�� _\{�e� �I ����r�hMg!R����]�� �<x�H尃;��͌3�e3ԫ&�"i�*��?R�c���gƸd���t�8�=�����B�&|g��t[���4��?���=���(�-�&��Z}��Za�]k :L�<��,G�aۦ�p���>#��!��,��A�^��5>��f_I��]�&�=v��_`�"���w�[j���Ql�ᆃZ4�cX����\+%���t����v|O�� �����7��N��"�Z�X���bI���:fj�0�,|3��D�x#N�o�Z�F�֗���Nf6��h��1y���Z.s
 {r�μ���z>��M�xhVڷ���k�r`�Y�.���[e�X���CE:�8��^�y�� ��̙��챯2N3�,ɸ��Wm3,����ք�$' ά���	J��vՀ��{%��!�~#�zO��k���k��
�n��ߔ��İ��桚�I)*��@����� Z�� ���i~������k��{��
�p֌�w��ӯ����\�`�1&N�|�@�7z��G�VZ(PL�\s�s%����ꅩ��F	���hf����fJ�k%�^)��tWf�3�Te�e�kW�MV���hU�ؔtwQ$3�L��W���-���P��^!��2H�g�"�K~C���9G�l�I
���b���0 .~sO|�f	P%v�e=N�o���G���t�:��k3�K���׃X�f��'4�M�2ZТ�U��^�5�%��h\��ʙeH�	N/c��7p�r׌o��aLI�G3:�F�� ��XSu��o[��c��d��a}��+��q ��pOfF	� Q/���#a�@*���U�w�f��'m�3����{���q�0�Ob���1�n��'�E�ԋ�z͑4{s�ņ0M#��z�d昫�f��6D�[�Lb?֯1�_��4���������Z�@r&mF�Q�×�,D�^lz��l/	"�S�nbp��a/�]"�<���_���t�2�_����v��:z�W̒�`�7���^"uG��@��{���4w�E9�w�QZ;�A�p�nVX̬p�C=ɑ�Q� O=�,݅y����~޴=4R��DT!�L$�㹧)zVn1���9���"5ע��I<�����3�ڰ7��5C���v�����>5!����O`�8-����c��&0g�w����{g����0%!
8�����y�i�<��w��?�p�!���kQJKC��M--�Pzˬ��yMI�-~�/{��č�8)q���Ț,JF��������?��?HR�F���!~b���kD)=����k��ok�KL�l=�w��%¨���H�>�`�&.��^G9�����f!b����Y�I�i�N�V�D.�w�0�g��.��&�R�QD˚=�j7�R��ٵҥ����۵�.vo9/gN��`�]�q�<�^o�B��c=�ԝX�+���՗�b�m-~4ݞ�1D���&�̌���a�_�f���?��:��5��D\8���,Dɓ߮�~O����TzB�d(�����O�G���^36R�S��lǍ��K��U+B�����8wG2����a�G�U8�\�  >���A�Ҿ��(�Dnk/��A�Ss,4�ӳ����$�U�w�|<+���_5��,>*+!��-�*��7��Q��oL�N�^i=�d���g��tD�Y�T�m�~��|&�1�E�Zl�d�#��I{��Q6�������D
; ~m��t��`�uM�W�SK	��`�uMu]�̧0]��۶n�*�տ�mq{ m�e�g� 0ɉI����3�?IG��
�v8kILV�"��w��FFP]��F�l��b�v&rߑ���g�!�n����%��:_�)�I-�b��H�h�w0��7�m�u?tm���@����'l�3����k�����I�[��Y�X��;�Y���Nވ<���Ιkr~��\�ɩsLs��>�Wa��J��&���Ϟ=���W��z�W�_v����J��B�#�S/�Gj�����7zJg�%�jef�3+Tڠ�xo�FJ7ӽKu:I�mS�9����@:�E�Ɣ�J^Xr��(D`����g���4�v�:`wf�� !*~���P��qpO�O8���N�+�n������NҲ�G�w��Y�P�Ҽ�l��^6C�C��x��37���Z�/�� ��Pu]�7p���Y��ʖ����=��̯q�N�iV���9u���#�C]�֪lf���j��`~{��< �i׈�G�<Q�|$S4���g����QR-4����([�	V�#4��b�&׺��n����	+ӆ0m�TpO�*g	t�]��P����Kڶ��nOI�?Eq�=K��,KT�7��F��Uhf �Zwan8�9�&�)p����D$6�ݱV�W��B�	c���3@�p�D��@��31"�%�����5C���r�ۥk��~� ���"8��.��g!b�C���8� 0��ӯ�,Qo������n��k�T�C��.әq
�����%Q���HlݺM����� �X��W�����0���!H�؝��g!���P;���n��M���U�̫��	}�a����"oH�In�x��.b�@�,Pi�봛�a�c
�)��'F�0"���V���eK�V�8Bu{�ݲ��    ��Rv���Yٕ!�\��u���XDVu�t6x
�!=��2:��GO�^�6��/�1�����%�Y�~�������g��O��1-3�4�]H�?ɂ$��M�[2��&�T[�X��ҵ�L��SS�(���W&F�l\<3�y���(�Q�~aX�K������ķL���xH�4�+�~�WEp���/����*���� ��w����T���ǖt��E�u���#8��gHx����=+������j����U�t@�����l�H�Bxw�{93�ԏ8��HD��	b��:�s�]{�7��Ou3wM�=�oZvZ�~C8l�޴������PU��Y����QA�k�p��CGOY�lSu1n��h]�D�w&�q�̯~!��ԋm�}St�^ʌ�_�G2}٨�Ѽs��}�<P�������f�v}�͸�2��#x��	M�  ���|�S��N|Qt-P�L���B��I)�#�_�$�Ѡ�揠�����zVQZ�18��{b�ʽ�8��	ջ^�B��MO:��;�Ϝ"�;����{6��ѩbf���z�}���ຩS�>l��8<�jB��C��	��<\{��7!+��:�Fh#�"ڐ����F�bf�M�������a� ��*�����Y��r5aM�ۦ�cڄ=Έ�C�G�����R�M���z���h�O$>�#�n?Ok3����ݎx_��TÉK>����JX���i�̗d�QO��j�=�R����6���Ć�29t7��7D�8"���K%3�Gk��-=n��[��nd��Cw^0����~��k���\��>�[˲Y�n���[_1F�Cp�Ͽ�c��Mp��=��V5Ϲ���^���D�|7���/�܈q�=B�B�ea't.<t��/f���孼Z~i�R�_|w�U9s�Իz ��4�>�0՚1B��@g��Y���E�q��Ў��C?�X(�P��:����pV���d̓��H��;���@���c���͇Z�i���Мǭl��aAy�����{yf1��,����&�#�3��L��ի��̏�0bӮ}������L�!q�qG3����Fz[5�HT�� ������_�h��>�8`�z!����T]\�x���+�z�L~Ƹ�E��#ZHi7\�>a�f�ݟ�ɚs_k�,[�h��'���(�ch��@�u��r�sW~�NO3�E���T$5��������7Q�ј�J���!�|+So�#�pz>�~����n	�U@�F
9�'06~����Y�\}�'��v��%����3 '1�VI9KP�|����
�sD��ᙛ�����X�(�cϦ�;�vR��He���-4+�d���=���Vo�����]���1ܟ�Y�1kMj1��(4����tB�J4g ���ѣ	I��i�{�z��
�6 {l�r�{�l43�i�[�Rn:��86B6"_S�*�x�`�����UAx;�̜��UwO�Nf�)�4TG�0�5`{ߋm�k�m�=���{ɂy���k�H�X�SK����ɂ��4>w��4��2W��k1�4���N){��4�B���O���^�hQ-a����nӰ�y���:,Ң��R��s+���)�=��oiDI����g�X��Q㪉�R��#�8O�b��-����)���V���3 �@O�^8��4R��e>j#f�f��A�H���Y���������$[��	��X43N�;!��5��5�=�2s����>�W�	Y����b�՝�g��X6�,��wB��M��p����P.��z��;�����y�%��	y�΋ѝ��ĿӝPD��pV}�!��ԣ`��d�Lŉ�>��^�*s�ꇛ^���@�V_�Z���OP�R,�˛���Ȕ^S�S-��������������;W��7�����s���tݾ�5!���#�6�3�e���48�y5Uf�g��H%m6�]7C�Y�?H�c��j����`�坒�b�?1�L	殞о��4s���8{
f�*v�A�Y�P}�x6�t����@LO�;� �����a\�ug���#H���S�Y�X�iްH�Fq�-��ջ�١H�Dq|-Mdr���O�����gAq,X�nWd_�E[�C�ç�Fz�TI�S���;8�7�I��N B"����㍘���'�v��&I�ЏL��9��Q��o_��#��bAoo�ڭ"CؚC8n���v�H�h����T��)��߫_Ӓ�	%�u-��n~�~M�0&*�s�s6����Nm4ˈe�4Q�~�j��d �N ����Z�I�������m$k^s��W	�����%K�-��<fς`W���fd�����g_�<�fDd&YU�5Xa�����MfFFFF|�g�[=.H6�����	�N,�OM�lY�ʢҽ�y��߶��[�q�{6�N_kh��^Bw؈U׋v�L=A�9R�uJ�>I`n*�u��@J����m#���d��8}���������
����v���4��8<��r��ޙ���VW��\��U+ӎ��~l�i��<��j�G0(|�P��:��׉8D�	�X]��
�C����-Kˊ��bOb����bCf2/�E��F���`:j(�c��2�:4+l�v�K̽'4�����|�b�둤U)!�^���pɣ �x�����lO�v�D��l���퐴�QA4hBD^B7-5R�y<n�͈�q�B��P]{"��$V���_�~z�Eb�,�U���1��)����e25�U>87Mm?Y�`K�h�ٜ��#�z���Ўjgݒ'=.�	��Zz*h�Fs���J����T(�v͆�VOUO���(_���$|J:���{YO����e���_w=߅��:م��1�H��t�\�۞[]�7�O)2��bK��(�z,��ͶݏĿ����#����I��h��|�.Z��{z�
�7�Ƿ�e"�3��Rߐ�ɒ�\���</�D3F�����C[P;m= ����P��ړj��(H�8 �rp
���R�,���=�TH�?��5�*Kd��X0���h���1H|�`F��zv���7CXss:�V-�� �ΰ�+���M'���{x0İܾ�X��z\�	����c�Q>kn�L����BiBy�'�I)�K�X@�{�v�]÷�$D�7h��RP�������ɒT[R��O�@�}=����~��t���I��Y�OO����s��[��ܫ�&�g꙼�%Z7+��=qT�$�Mr�+�5b#L[�<|p��Kke�Aۂ.9�g����H	7*�Ö޶����V� 9�G8��,ߝ�.P�ު��^�����+[u&�Q�n9��,=iv�f�ԁ���~�}mױ��
@�W@�'��t�J�pƓ.��'��aP
�u��$/�b�d��	~ك"�
gK��^� ]��B3�����z=�9L_��y���Ҹ�R �&odv��9F�/��hQ7Ͷ�]ͥ���WF�m�ը��Waq��Yį���"�������Pr�>��G������y�=���U�B������u�']"8X=�M
�F �p&�N�l_5S�1G�u��s-�I�8��[v��M�����N�ݼS�T�������2�S�tR*	���];3n&m�ЊϿ�S� M��l���H�X>=���� 5��X�L��s�9��jL�=W*���Ԫ���
�
�L�������O<S��r G���|����(3Hq�'m�jQ�E|��bR"l��̹r�:H}/�/��(�ēD]y����7^�+>Ɯ*�0��ةJ2��$���}���� ��~c�ĥ��٥�[9��N���܁���a�鹲�,t��G/4��.Wk��7�<o6L�r�V%��`I�f���O��z���F�0�W��z�P��¿�_ �h�TD�h�����f��{աx�$�`J��Q�j���N���4�m���M7g���*��EHUg����c��6q�`<)� 	��e���]s��p_���g�[�,c    @�%�0��L:����v�t�?�Sd3�q8Un�U��!�Fv��Y���su�Ie���U3>�O�&��+/{[�1�}���/�CiB萞+�MJ����\�t��ޏ؂��\��*�s�I�B�ݻ݃�
�
�x�aơ�ղ�C8s\�!:!'b�|�v�E|��R���FP����p�&=�c�~��H0U?.��[�\�x�P���Z7��t�3�F@3Ǆ���M+\b+6] I��y�~2�E������ܮ����p�tR,�<���+�/{/DRZyiL��i��Ϲ:٤N|��AU��.��q �{��k�~�$7	��z۫��CeL&0ds(�����~��������`��B<�H�4�\?�N�s͝�VL���
6�U|Q��mw�V;�_���if)��%�Vy�N��<�;�_���R��\�N*����Y�W-�Nen��SQ+x��m&*	Oկ^m��2����]���R�Y}p&��>r�z3<����I��b��m�4$P>�.��_љ���k�QC�6����)�\f,�/�ѽ�Us�n���R�X���є���v�)��ب͓n����	�`���Oy���æ�6���O\��q��Gœ^1e������S؃y�r��G(�*��%"�x�n���W���G�����@�c�~/|��+��t�=����U�PwQ��mq*a��#�%I]q���)*��e��o�g��.��/ד�T�%_�^9%�q������؃y��\�ERK_=�Q�^�:��tr!A��S8��՗��+�l@��Z�k�@S�|(;�����V5�)Zd#��2�E���`�JboE�VF�G���o[6�l$(��gx5O ��Ȅi�@|lq�.lq�`A���Y:=#�S�Zl16X�����I���D�l�-��ZP�`e�Z��6�F8��|�	y2Pځe�|R,	�4Ԃ4�<7�_�Zo�,a��k��h5�E=p�n�yՊI�4xe��z�vz�<��rx��L��H9�r+I�t3�g6-����yx$i��^Gh
����z�Oy=���;���hػ�by4*��I&�
��8��ܹ$h��u`p�d'�陸6K��z�x��~�V�/���Ȝ�ڝ>��Mn3�MJ���esGE�$=ү�(�J�ϭ��Izk6���.H m���»�s�=�6�k5�I׈Ҳ��=�N�����qi
G<IxX��JP�BX�	���P�DB�BsCPI�#]��,Q�P�<��-��ЂF8�n�?�6x9�1�J���l;#�]VCC(�×PhȨ��Ǿm7w�P�����RC7L�Q������u3�5�&����jٓ���D`Z�N�涋G�y#���g�r��L�$���)8w�Ů5X&���+J�[�\J��B�t�Zng�S@G�t2���2HI8(FN����.G�	,Z�h��1��i��4KnN���k9�R2�LB�LJF�G�m��%a�kp�@��2��+�􈃛f�o�!$9��2���h>����Ow��]�Ikܨ���a;t�_��U�q����Fp�Tw��M���J�龍9�`�?�0�P0�:dJ��=Vo���$��W��9�4��ɩ!1F��g4#[��O@�]�N2�Q@�Ε�6ؖF�"NTÂ�<�ˢd�X�����\�ԈU�ܛ!ܳ0�%Q{7��Z��]hg�;.b�u�����PV���֧\�3h�-�O�cDk=^�qG��Pty�鴫���gC��+���A��Gv��*:�U�]��br\+�$�GSp1��紘��7+J�B;GQ
o껳3���/M��������G��/��d�N��I,�F�٤�Qۊ��GM�D�_အC���|�%��܌;e��I�֠���C?��_V�	�m����2�|���ͬ�i�Nĉ���_f�Qj��W�����۝�r"ra�k�c���h�2�[O&� �s�f��;��؎KjK)�5�/�L
��o�-n�Dqqq.嗕M�Dt>������Z�N{"�p0���i�}�c�0J���ZSO�߀W<�i�wG�G�ke �]�����#�SS	��$�X`���b���co`u��_��Vʂ��y�3�I�4���#k���HV���!n����e�QK&���3��o����ݑ��j��ܳ�â5Id��tR+���m;�9���i$�k�_0�&,M/��*��*�&W��:�*B���{���,��YR?Ư�vd��O���ԣ��J��w��L��x�4z���%�y{od�\�^��I:�(�BJ��� �V�h����,Z�2�V�D%x���c#�G�vJ>�$��Qp�5�:����x'o_[��M`:�ˑ�t�+�uS���}m��v� �`zɋ�"�{ژ�a��u�.{�b�>Fw�=�{$I�x���r:�=�0����OP����Oj�� �v}�]7�pt��O�����/񴢀�VR ë����5l##ao��"3�/��Q&?�r���aDM���{qX"��ֳ�
�Uv���"/4��2r�kV+���a#J2��t�39#/�t(�\wJ���:0J_���s��rL�S�:����ؐ6F�i��c��g����d���*`�[��R,HW(�o��-ޯ9��S�+��H;�aVтQ+>v%��T��
pMP�KP0�%�0�r�Ƨ����"�I7��6�M�J��:gr�:-Mo2CE6i��W�0�U���!w��T"$��(����|�P��/q���vx8��\��cE8�9F��MȖ$��k�;lc�v��O �����￐i=�I�ep�tw����4�	%i` �'�S&��	���M��vgr�p��W_��'Qμ.QwzZ���sМ>� #;
(��}��ӷ�ˈ�%Y��xU]C\��nk(?A����V7�=�>e��y�?�w���9L��x��KR$Q�@e-�����3u�g �yw.��P����Kx�X�*H�~�����ɂwͰm!���F�R���c��u�}E�N���7[d7�Q#ҫ��ŀ��&E�g�ج�?����~E4�cޥ��XB���߮�����[�������?r���� ��e��|A
��T�
7����7Ԝ=D�g^jj�i��w�NϺ\�{z�r�:�w�3�EP1><v,ѦS�H�\��y�2�|��(�Y8���]���n��L+�\uװ<���(aR.8�&M!��B�5˔�|+�̿��t��!�I�4����K���4���1�t���<"�PM5���y���}ԥ!2��&Os-1a[g�p�KLt�ܻt��BLYv5Ny��9����ĥ����)�x�͜(�0��RK�٠�����R���la�j��g��g��d69J36&�������˧n$��i�z{������B.5L'������ܑ;�f�g���|���&�oƺ�����e$��:+�ӌͼi�F������?c�����ز�/R+Qm������F�Fb�}�l�����$1���#��pv4 7�ŷˉ�0e�>7O�ϔ-b��`<IL���]ʉ��$1~n�ߏAT:�D����������4�-�x�t}���7u�U���3`��Q�D=��_�>#P���^C����fi��j�%Mȭ�I�2��vku���t���f����X�0�I8��՛��~�L�"w�� �̛?��g�|9�Z)�m�F���y8�7JU?�k6��(�g߯�ֽv��S�µ�q�)M7VE��t}�)�i\����$�xO�Z,�5�W���ݓG(S6��$-��:~�֫�\Șe۬��ƪ\R�G���ƨ���-�/��6j�U��_�q�l�cM�h�K0[7��s&gC���'���!��{��zܽ+�A��}=s��g����>r�<^è;^NC:��ט�,-=��3�a���'�;��>�\X
JlU��ԥC��{�aN ��dxA� �%�?�h]��S3�����A�P���e�4�3}���50��Z$Z�� �jB���I�Ĕ������Zv�^��y*���-��h��䥃sʤ��z�@������    �u)f¼<��M�|��Y�i�!����?s,4�������3�b���&V6�eB��O���f�l�޿�B���C� �.:�v�5�}���1������Y)��u�z �ǚ5ݢGKg6�
��:|��	70*���e2���8�ߢ�-c�k��U�{PT�&o�g����@�9�+�z���[��V�d��]����3�� t����S
�� ���ok_�;7��j"����SL�[U"u4�c��oF2�:	�>��f����!������N�Fr7���e4����Rh�yc)���[s�S؜��V�s����k��>r�S,��&�u��>�s݅�P�%�<YT��_N�N �A�1j��[8�0�vk�(�6G�,�C�����}�=�]�i��`����u�'��
��Z57�;$nrg9B�h��q�L�a���LXZ�ŬF�5�m�9ڞ��5�kݯ�	��D�ࡴ�=�So�5�0uP"8��vީaպ]�<�>�;px������ªXB£:�c��S;�;.�`pՈ8�F� ��[��pڨw��w��?�)���j����0�"��p�3ZeO�>��EX����P��K�սܜ��Ա5rϙ�c�6u��%ޫw�N7;���o��w����O�i���y����r:�J@��Nj�8vh���S�4J���[7#8U�M�_xʁ��w�xݗ���mݱ�/��[�����}�ӆ{�F��B����z?�X7��V�=���
��TK{��|��uϥs�`�Y`��0G�,�߻�j�p�0]AJވ(ƊA��]f>]Z=� ڨ�
������]���v������3~�L���V!�����;(gٰ�+D"A�*P�h�F:y�zV�2�7���F�o�]$rsDc��8(;���)��3�yJ��<}��;}H���;K���v��ǅ�0
��w�U+B�'��ȶ��t�<�u�m#p>��U"�u�
���������Z9r�r;�T�[#�]e�H4��?L�rp��L-7���b;r�O�k	�P���C˙u��,�S�Rho�����A9���3<�/~�,[��K��d�eǎj�a�:�01K���'%�(N�޲�Nɿ��Ѽ��[����q�֖�ԓ�RE�(��9Y�O��0#���a�3;�4J�QrTsiDcpլ��� 5��(<��qa� �@��(�Kf��Y]���n`�P
��7V`�z%tO6��756rpN�Cch�`� w�ԣE��i������^�k�y�ԓ�k�(���B�T�銭Q�Z�)������<�jE@q�ȯ�������O����+������Q��/��NtH�k�=��oO�@�x��,�o�3+>&{��џ�ͩ0�M��se��>Gn�� ����p���k6�H�=��q���ZX�~���k?<B����0� �l��wM� �3��c�K�Y|9��椻M١	L��4��$�'K+X�Ӈ���Ӊ�+�&Gn����
ǖ|��PȮ�2�F�2xWo�Z��-�A0��;�U�澦=��k9�b�h����p�L�uh�����M��4%�f3����:����o�T��-�ְ8�# z�����I���pZ�<>s�}�
��=>�u8F��XW�I�b�o��{�#-�|�]^#��2��u�g������ W�7\��c�k@Tc�4͆)��Ǌidg���sw'[�������d��;���}�:����n��HE��[/;��=���܊/����m����Awj�P�]^��Z3�P�ҽ�btT���p&W�,�e�z�nu���kp;Hv��i9E�4��+g��B�+�Nm�0@�#�?�͊�|;����
8*hNۃ��ۃV6
�Bs�ߟB���ڌ;`�p������A����1���jd-d+�e���so���a�9�v0����S}��!�����L&;xI!cd`�o���j�u_�N�����l���Y��e	�6�Z7wOIh�ik�;�������C-
R(��bb���:J�� �kl6N��s�a���;�f���� 8@�R����h/�v���s���g�F񅗲mN������A�=�+:{��Fq�yX�3#8��÷v;���~�%�mS
�d�� :i˳j��j?�������5C�_C����"�?}�� �v�Sn(mх�,�����C��fc�	���vj���}#ܳ�C��M���j���+tιj�w������p���G ���� ���t��o���&�Ӣ��۵c�m��6I�4OP���ƖZw
�m���i�n�d��@f�o�7�P�;u���k;�Ag�ިER�h�5"[����y�j������	�|�bͣz;?ջ����|ݡc�^
JW��-��'�p��"{�xf����>ݻ&������"�$�[�	EF�qUcc-�քI�pDA��[Hq�MK6�j..I�(x��s���|l(A�����12�il����2��������N�*�;ao$8��x�p�3�`ɱmyb5Tvs���I��*GϜs���v��pG0��<�P ]�9S�J�v؆v\b�:YUL
�"���$+yY��F����Gzx ����ŏ!T g��V�<�����<N��\%�4�F�C�UX���݁���:O���ߡQV���s�0��[ul��h ��l���Ҫ�<�~�mV;N�3y�4F�qr�DiE�>j.��{�y�\�1�� ����¨P,�I%&.=�o�O�=;
󑞫�$s�������R��/}��0\�]�c.ԃ��,e3�����k�.�ԏl/�'tW5��<Ɨ_���a�b�Pj�aϝ=0ax� |:1�Rٛ'�j�`���0���|#�Y�j����k�`�Q>pO�|�Äޞ=�φ)M�Ѝ��+�P���m�?<�P���q�O�M0��m�2t�<����6��A��cԌ/I�"�jw�����_Z�&��?�[�O��=��_��o-���a�@�����K̼�����F�(��Rn5R9��^�����U�U����a�a��)��f�p�w�ʅ���O
�N<�u�n�������n��ʓ~��/��_n RA&���2'�r�nf�Gʢ5�vBE�j��'O�-SuA�����[=b:5�Ү�:$<=����(�lS+5	n�|�5#����/�:�lQ~��Խ�F<a�Z;BPlO�<�V7(U�;(Lpצ2��p�B'�i)��6��6���6�d?9�<	-3�6�0���T��Z�s� "��B1�#�%�k�U/H�"P��V���q-�s~u���%r{�f��_�='�*,�W��췻�KO� T����0��eN���.�[�bw{�+�������S�;��Ev9h�����҈;��c��I(L]�|ŧrHf�G��Z}θ�;L�o�|�T# V�Ԡs���;�a���%9��"��7uw:���f�X3۱��ȑ�U!U��f���2{�F�ő\ETZa�:D����Z���U��O��������"��O��_+����!|ӏ;��:�BrB��0@W���*d�T�/��D�������^�����x��RY w}�ų����+O�tk�%:iW������1�f�=��aD@�0��*=EQy�L�Yۨv��luyH����Ƕ	_�\V�]����b�f��X�1v0�J������d��5���'�ԝ,�AD��φ��^��V8���GR����G�r�T���\�NBy$ R��Y��g�=��k�E�n�B�LH&Xu��w��mTJ)��݆��T��	b0˹�V�ב�AFOf�H��ҩ�%w_��i�/r�Fi���6����]Wo���ou�T
dKw��Ft�3U�����>Ep�Pu����@�@L�s!5��\s�L~�d�H�%ۛ�.�[Ɵӛ'3��� }�a�1��l�mǇ��9(��#A�ǆ�a��k�_�!���b�a~Z}����yAα�=l�ͪ�0w��	��G��<�UEʶS_��~;�CK�e����p�ՠ��]� �  ����+N�4>n����j�������i �/fG1Δ��fr+XM-��/b�pg��̯�5;@T
49nKy!3]���cD�_����NY9�yJ��Ռ�������ujEAH�~^��<��R2+j��ö|!+���QnE���"}��U�s��2WQj1.�ɾ�E-��T�Ip:�h��Ǖ��R_�x2荤8��a/�%��y�/})�F,x�sE�ň.�N����_�H�jD���%�	�ڍ8�Ӏh�i�Qʗ���j#SFQ�&�`=�T'{�p�~�ܹH�*,HD&$�pXFֆ(�%�iW#��D���{�.[;�W�A�$Q���q֖�����B�I��C�28�%Q)�o'����;�\Y����V%^�Z�.+�VE�O�����~?������]S���4�g�n��o��u������@u��d��H��s3�� �s����v�؆��m��K.��P��x�,F��k3�.>lM�셻8}��Gy��+�d���p�,H�~l����m"gds���0
��.ӗorf�A���d1�5B�59)`&�5���f���YCd��n��i:X��w�T�2x߯�v��L^�}�2I�H �r�[���{R']�[ ��/�d�8��@L 9"�'���ӹe�=Snj��S=@�0-o�B�4�[��� �!�{�����z��Lf
��z�z���_�]�e`��y��5����L���B�y	 �R���{Sw߀V��v|��"�h� ��x��g�ly�:g����D
����u���=�U?o_r9/��k*f��C��r���R
)�������Ÿ|�N�׆��X&N\�#:�F>�ϔ̓���=���\�7d�����5~�%�4�uu_�W�@�YB�G�)VPz��q��j0 i��H�E|�R�HS�w�ݾ�?�㎭��5��q�rյ�ru�TI,jjA �;�p$l�S�ꎰ��v�uڥ�H��W�m�������m����V�E�^]�{eQ�߂Qv;�
q�֓H�����]���"�%;֛�[�)s6��u����
�FLC��Pߛ�u�3������H�b�	��J}�A�$H���ՙ
)^�~�����k�.|q]75�tw27ܪ�	�xw�	A�s�.&�#�33�>z�ٴ��7}ɟ_��?5�GY#�)RǄ�]"�Y�rDq�QR��^��^�z��zɱ�B���}S�+n�gh�;q�^�x!�kӬ)]�n���`l���L>�V�a7�@i\��2͙���cs���cs��ӗ�lî��(�@��᥯U�M����ӱ~�;�^*�%�9�dL.�w�E�9����0(y�����.�`2`�Bf"�����D^�9��D&׺����=|�j ytь
v�F���X���¾�bIp��W�;�R0�uz���y|�ok�������C~y	74�-���&L�]���&Y��*��c��:f�`�I(ըQ��q��F�%�M��7��$��QJ�K+UC�q���c���ǽ������Ź�|��%f>�wx����K6�������>gX�Ӝ]��^�.�L؟��������6�1Ĉa�c�"O/�-�h��iV\� qT2йr�Ll���_fx��̢�[X��"'H֖S1gŐ�2"㷙7n��;�Ϛ��g�������o��h�      �   Q  x�Ś�v�8���O�E�3�р���C�N�$�ɜ�P��,Ѷ�8O?U���3P��j�w,K�_rNV�q����zXm��\�>'�s;�<�nf�O�Ǉ���k�s�=돪�o�떹��n��������K���)]T�5�@	mHZI����Ϥ#Zɗ���7��֠��~J�Ě�>u��T����UT���w��M�N��E���s�Ӟ]�z��<��i{��lS������~��LZSl������F2��[�6�t`��.3eJ&���ENS�[��8�Ux&�X�*�����ڛ���ЊXV�y]�0�+q�kD�^�5�� ��r��X�sy!�Y`^�!��
�ϕ�$�&�Vk^��+�T*�U)H$,�U)x]�-����O}�m^X��,f�iÅZn�<5e�W$Y1�$p�ʴ�*��m�e�Y�WFe�Ԫ|C*I.��E���(�<U|$�Q8y*��у���3Wv�(���*}��f��\YK*> �'�2��F��8�U5L�-�TD�"C�{g��~��d�Pք�*#�U�T[qi�JPn�J҂;��wK_�$R�.�5�po�'+��9\"IE�,��C^�c���]`�P��8���Y�>�*/��>�2�u�0�nUc�T����*�4�
�P��[�\��\���!��3���Y�J��������2��,3�ōZ��r_��X�e�0������Jaߟ5�,3��v�
S����@�hJ�i�L�ia\�^�s�ՒH��{Nuژ����F3�V�"�XaJ`bq=��E�2���Gu:05���\_��];]8�>_�s�[f�����c�L	��av��Pj)N��FC��N�,3��f"1YU*_�Qz��Ա��3�K��oꋦ��˗��2#�R;�-ϼ{S6�2�*r�T�O�Z�!q{�u�|�Nu$CE���,Ԇu�*�2�:�W"f��l7�%.�uȒ�rCȬҁ�\�~N�%�?'�vC�\b#�}�ߣ��`bf�ܚR����G�a�}�+�^�kl�.�'dV�=5�7�Y�*��1��!�P��*d��f���Ƨq���02{dYDf��h�\Y�qĽ��U� �P`�iÓ�u��rc�}�V���,����;��#Oxy��rO�,���*s\싘!Q�"b��I����u|����׃q���;�O���"��u�p��T瘤Iȇ��^!#�,4�o:כ�C��1N}{C�쵭���M/�@��X`���ڃ8�?]4Gh/T�˦�|ۂ3j3���5u�+f�6�k��b��\�z$���Y%�iƤC̏VaD:0Kt���ו����h�&f���em��G�s�����Z|w��x�hki2�����#�e�ǈh��<�w�&�׎��m���;G��t��ǳ�n�Y��9�9"7���_���[��zWǽ0^;���2m̊V����qnt�� �*0�$p�).r7��a+,�-1�L�qU�E�	e-f�.<غ(t�#!;z�h����u�����nЇy��Rܫ��p�Y�20������a[ƣ���qG�,3�g�#B�Q�U�},���2#L��͍�o�����R����k���q�~څ�H��a�,ц1�\�����j���������b��     