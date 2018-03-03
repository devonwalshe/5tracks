-- artist
ALTER TABLE artist ADD PRIMARY KEY (id);
CREATE INDEX artist_name_idx ON artist(name);

-- artist_alias
ALTER TABLE artist_alias ADD CONSTRAINT fk_artist_id FOREIGN KEY (artist_id) REFERENCES artist(id) ON DELETE CASCADE;

-- artist_namevariation
ALTER TABLE artist_namevariation ADD PRIMARY KEY (id);
ALTER TABLE artist_namevariation ADD CONSTRAINT fk_artist_id FOREIGN KEY (artist_id) REFERENCES artist(id) ON DELETE CASCADE;

-- artist_url
ALTER TABLE artist_url ADD PRIMARY KEY (id);
ALTER TABLE artist_url ADD CONSTRAINT fk_artist_id FOREIGN KEY (artist_id) REFERENCES artist(id) ON DELETE CASCADE;

-- group_member
CREATE INDEX membership_idx ON group_member(member_artist_id, group_artist_id);

-- label
ALTER TABLE label ADD PRIMARY KEY (id);

-- label_url
CREATE INDEX label_idx ON label_url(label_id);
ALTER TABLE label_url ADD CONSTRAINT fk_label_id FOREIGN KEY (label_id) REFERENCES label(id) ON DELETE CASCADE;

-- master
ALTER TABLE master ADD PRIMARY KEY (id);
CREATE INDEX main_release_idx ON master(main_release);

-- master_artist
CREATE INDEX master_artist_master_idx ON master_artist(master_id);
CREATE INDEX master_artist_artist_idx ON master_artist(artist_id);
ALTER TABLE master_artist ADD CONSTRAINT fk_master_id FOREIGN KEY (master_id) REFERENCES master(id) ON DELETE CASCADE;

-- master_genre
CREATE INDEX master_genre_master_idx ON master_genre(master_id);
ALTER TABLE master_genre ADD CONSTRAINT fk_master_id FOREIGN KEY (master_id) REFERENCES master(id) ON DELETE CASCADE;

-- master_style
CREATE INDEX master_style_master_idx ON master_style(master_id);
ALTER TABLE master_style ADD CONSTRAINT fk_master_id FOREIGN KEY (master_id) REFERENCES master(id) ON DELETE CASCADE;

-- master_video
CREATE INDEX master_video_master_idx ON master_style(master_id);
ALTER TABLE master_video ADD CONSTRAINT fk_master_id FOREIGN KEY (master_id) REFERENCES master(id) ON DELETE CASCADE;

-- release
ALTER TABLE release ADD PRIMARY KEY (id);
CREATE INDEX release_master_idx ON release(master_id);


-- release_artist
CREATE INDEX release_artist_release_idx ON release_artist(release_id);
CREATE INDEX release_artist_artist_idx ON release_artist(artist_id);
ALTER TABLE release_artist ADD CONSTRAINT fk_release_id FOREIGN KEY (release_id) REFERENCES release(id) ON DELETE CASCADE;

-- release_company
CREATE INDEX release_company_release_idx ON release_company(release_id);
ALTER TABLE release_company ADD CONSTRAINT fk_release_id FOREIGN KEY (release_id) REFERENCES release(id) ON DELETE CASCADE;


-- release_format
CREATE INDEX release_format_release_idx ON release_format(release_id);
ALTER TABLE release_format ADD CONSTRAINT fk_release_id FOREIGN KEY (release_id) REFERENCES release(id) ON DELETE CASCADE;


-- release_genre
CREATE INDEX release_genre_release_idx ON release_genre(release_id);
ALTER TABLE release_genre ADD CONSTRAINT fk_release_id FOREIGN KEY (release_id) REFERENCES release(id) ON DELETE CASCADE;

-- release_identifier
CREATE INDEX release_identifier_release_idx ON release_identifier(release_id);
ALTER TABLE release_identifier ADD CONSTRAINT fk_release_id FOREIGN KEY (release_id) REFERENCES release(id) ON DELETE CASCADE;


-- release_label
CREATE INDEX release_label_label_idx ON release_label(label_id);
CREATE INDEX release_label_release_idx ON release_label(release_id);
ALTER TABLE release_label ADD CONSTRAINT fk_release_id FOREIGN KEY (release_id) REFERENCES release(id) ON DELETE CASCADE;


-- release_style
CREATE INDEX release_style_release_idx ON release_style(release_id);
ALTER TABLE release_style ADD CONSTRAINT fk_release_id FOREIGN KEY (release_id) REFERENCES release(id) ON DELETE CASCADE;

-- release_track;
ALTER TABLE release_track ADD id SERIAL;
ALTER TABLE release_track ADD PRIMARY KEY (id);
CREATE INDEX release_track_release_idx ON release_track(release_id);

ALTER TABLE release_track ADD CONSTRAINT fk_release_id FOREIGN KEY (release_id) REFERENCES release(id) ON DELETE CASCADE;
-- ALTER TABLE release_track add column tsv tsvector;
--   -- set up custom config to include stop words in queries;
--   CREATE TEXT SEARCH DICTIONARY english_stem_nostop (
--       Template = snowball
--       , Language = english
--   );
--   CREATE TEXT SEARCH CONFIGURATION public.english_nostop ( COPY = pg_catalog.english );
--   ALTER TEXT SEARCH CONFIGURATION public.english_nostop
--      ALTER MAPPING FOR asciiword, asciihword, hword_asciipart, hword, hword_part, word WITH english_stem_nostop;
--
-- UPDATE release_track SET tsv = to_tsvector('english_nostop', coalesce(title, ''));


-- release_track_artist
CREATE INDEX release_track_artist_release_idx ON release_track_artist(release_id);
CREATE INDEX release_track_artist_track_idx ON release_track_artist(track_sequence);
CREATE INDEX release_track_artist_artist_idx ON release_track_artist(artist_id);
ALTER TABLE release_track_artist ADD CONSTRAINT fk_release_id FOREIGN KEY (release_id) REFERENCES release(id) ON DELETE CASCADE;

-- ADD JOIN field for release_track - second query takes 1.5 hrs with reduced set
ALTER TABLE release_track_artist ADD id int;

UPDATE release_track_artist as rta
SET release_track_id = rt.id
FROM release_track as rt
WHERE rta.release_id=rt.release_id AND rta.track_sequence=rt.sequence;

CREATE INDEX release_track_artist_release_track_idx ON release_track_artist(release_track_id);

-- release_video
CREATE INDEX release_video_release_idx ON release_video(release_id);
ALTER TABLE release_video ADD CONSTRAINT fk_release_id FOREIGN KEY (release_id) REFERENCES release(id) ON DELETE CASCADE;

-- rt_test TESTING SPEED OF INDEXES
-- ALTER TABLE rt_test ADD PRIMARY KEY(id);
--
-- CREATE INDEX title_tri_gin ON release_track USING gin(lower(title) gin_trgm_ops);
-- \set var '\'%storm on the water%\''
-- select set_limit(0.1);
-- EXPLAIN ANALYZE SELECT release_id, title, similarity(lower(title), 'storm on the water' ) sml
--    FROM rt_test
--    WHERE lower(title) % 'storm on the water'
--    ORDER BY sml desc;
-- -- 0.1 threshold - 7.6 seconds
-- -- 0.1 threshold - no wildcards - 7.32 seconds
-- -- 0.2 threshold - 3.2 seconds
-- -- 0.6 threshold - 1.1 seconds
-- -- 0.6 threshold - no wildcards - 1.0 seconds
--
-- select set_limit(0.1);
-- EXPLAIN ANALYZE SELECT release_id, title, similarity(lower(title), 'storm on' ) sml
--    FROM rt_test
--    WHERE lower(title) like 'storm on'
--    ORDER BY sml desc;
-- -- 0.1 threshold - 543 ms
-- -- 0.2 threshold - 548 ms
-- -- 0.6 threshold - 555 ms
--
--
--
-- DROP INDEX title_tri_gin;
--
--
-- CREATE INDEX title_tri_gist ON release_track USING gist(lower(title) gist_trgm_ops );
-- EXPLAIN ANALYZE SELECT release_id, title, similarity(lower(title), 'storm on the water' ) sml
--    FROM rt_test
--    WHERE lower(title) % 'storm on the water'
--    ORDER BY sml desc;
-- -- 0.1 threshold - 7.6 seconds
-- -- 0.1 threshold - no wildcards - 7.32 seconds
-- -- 0.2 threshold - 3.2 seconds
-- -- 0.6 threshold - 1.1 seconds
-- -- 0.6 threshold - no wildcards - 1.0 seconds
--
-- select set_limit(0.1);
-- EXPLAIN ANALYZE SELECT release_id, title, similarity(lower(title), 'storm on' ) sml
--    FROM rt_test
--    WHERE lower(title) like 'storm on'
--    ORDER BY sml desc;
--
-- DROP INDEX title_tri_gist


