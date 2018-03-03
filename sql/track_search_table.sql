-- create search_table, first fill tracks with track artists where possible, then any missing fill with release artists
SELECT rt.release_id, rt.id as track_id, artist_join.artist_ids, rt.title as song, r.title as release, artist_join.artists as artists
INTO track_search
FROM release_track rt    
LEFT JOIN release r ON r.id=rt.release_id                    
LEFT JOIN (SELECT rta.release_track_id, array_agg(a.id) as artist_ids, string_agg(a.name, ', ') as artists
          FROM release_track_artist rta
          LEFT JOIN artist a ON rta.artist_id=a.id
          WHERE extra = FALSE
          GROUP BY rta.release_track_id) artist_join
ON artist_join.release_track_id = rt.id;

CREATE INDEX track_search_release_idx ON track_search(release_id);

UPDATE track_search AS ts
SET artist_ids = artist_join.artist_ids, artists = artist_join.artists
FROM (SELECT ra.release_id, array_agg(a.id) AS artist_ids, string_agg(a.name, ', ') as artists
      FROM release_artist ra
      LEFT JOIN artist a ON ra.artist_id=a.id
      WHERE extra = 0
      GROUP BY ra.release_id) artist_join
WHERE ts.artists IS NULL AND ts.release_id = artist_join.release_id;

ALTER TABLE release ADD PRIMARY KEY (track_id);
CREATE INDEX track_search_artists_idx ON track_search(artists);