CREATE TABLE queue_tracks (
    id integer NOT NULL,
    track_id integer,
    release_id integer,
    release_artists integer[],
    track_artists integer[],
    queue character varying(255) DEFAULT 'scrub'::character varying NOT NULL,
    popularity_rating double precision DEFAULT 0.0 NOT NULL,
    underground_rating double precision DEFAULT 0.0 NOT NULL,
    similarity_rating double precision DEFAULT 0.0 NOT NULL,
    total_rating double precision DEFAULT 0.0 NOT NULL,
    in_library boolean;
);

ALTER TABLE ONLY queue_tracks
    ADD CONSTRAINT queue_tracks_pkey PRIMARY KEY (id);
ALTER TABLE ONLY queue_tracks
    ADD CONSTRAINT queue_tracks_release_id_fkey FOREIGN KEY (release_id) REFERENCES release(id);
ALTER TABLE ONLY queue_tracks
    ADD CONSTRAINT queue_tracks_track_id_fkey FOREIGN KEY (track_id) REFERENCES release_track(id);

