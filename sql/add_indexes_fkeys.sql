-- artist
ALTER TABLE artist ADD PRIMARY KEY (id);
CREATE INDEX artist_name_idx ON artist(name);

-- artist_alias
ALTER TABLE artist_alias ADD CONSTRAINT fk_artist_id FOREIGN KEY (artist_id) REFERENCES artist(id);

-- artist_namevariation
ALTER TABLE artist_namevariation ADD PRIMARY KEY (id);
ALTER TABLE artist_namevariation ADD CONSTRAINT fk_artist_id FOREIGN KEY (artist_id) REFERENCES artist(id);

-- artist_url
ALTER TABLE artist_url ADD PRIMARY KEY (id);
ALTER TABLE artist_url ADD CONSTRAINT fk_artist_id FOREIGN KEY (artist_id) REFERENCES artist(id);

-- group_member
CREATE INDEX membership_idx ON group_member(member_artist_id, group_artist_id);

-- label
ALTER TABLE label ADD PRIMARY KEY (id);

-- label_url
CREATE INDEX label_idx ON label_url(label_id);
ALTER TABLE label_url ADD CONSTRAINT fk_label_id FOREIGN KEY (label_id) REFERENCES label(id);

-- master
ALTER TABLE master ADD PRIMARY KEY (id);
CREATE INDEX main_release_idx ON master(main_release);

-- master_artist
CREATE INDEX master_artist_master_idx ON master_artist(master_id);
CREATE INDEX master_artist_artist_idx ON master_artist(artist_id);

-- master_genre
CREATE INDEX master_genre_master_idx ON master_genre(master_id);

-- master_style
CREATE INDEX master_style_master_idx ON master_style(master_id);

-- master_video
CREATE INDEX master_video_master_idx ON master_style(master_id);

-- release
ALTER TABLE release ADD PRIMARY KEY (id);
CREATE INDEX release_master_idx ON release(master_id);

-- release_artist
CREATE INDEX release_artist_release_idx ON release_artist(release_id);
CREATE INDEX release_artist_artist_idx ON release_artist(artist_id);

-- release_company
CREATE INDEX release_company_release_idx ON release_company(release_id);

-- release_format
CREATE INDEX release_format_release_idx ON release_format(release_id);

-- release_genre
CREATE INDEX release_genre_release_idx ON release_genre(release_id);

-- release_identifier
CREATE INDEX release_identifier_release_idx ON release_identifier(release_id);

-- release_label
CREATE INDEX release_label_label_idx ON release_label(label_id);
CREATE INDEX release_label_release_idx ON release_label(release_id);

-- release_style
CREATE INDEX release_style_release_idx ON release_style(release_id);

-- release_track;
ALTER TABLE release_track ADD id SERIAL;
ALTER TABLE release_track ADD PRIMARY KEY (id);
CREATE INDEX release_track_release_idx ON release_track(release_id);
ALTER TABLE release_track add column tsv tsvector;

  -- set up custom config to include stop words in queries;
  CREATE TEXT SEARCH DICTIONARY english_stem_nostop (
      Template = snowball
      , Language = english
  );
  CREATE TEXT SEARCH CONFIGURATION public.english_nostop ( COPY = pg_catalog.english );
  ALTER TEXT SEARCH CONFIGURATION public.english_nostop
     ALTER MAPPING FOR asciiword, asciihword, hword_asciipart, hword, hword_part, word WITH english_stem_nostop;

UPDATE release_track SET tsv = to_tsvector('english_nostop', coalesce(title, ''));
CREATE INDEX release_track_tsv_idx ON release_track USING gin(tsv);

-- release_track_artists


-- release_video





