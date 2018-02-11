-- Get label from track
SELECT *
FROM label l
JOIN release_label rl ON rl.label_id=l.id
JOIN release_track t ON t.release_id=rl.release_id
WHERE t.id = 1;

-- Get label releases
SELECT * FROM release r
JOIN release_label rl ON r.id=rl.release_id
WHERE rl.label_id=5;

-- Get all tracks from a label
SELECT * FROM release_track rt 
WHERE rt.release_id IN 
  (SELECT release_id FROM release r 
   JOIN release_label rl ON r.id=rl.release_id
   WHERE rl.label_id=5);
   
-- Get all artists from a label from a track
SELECT * FROM artist a
JOIN release_artist ra on a.id=ra.artist_id
JOIN release r on r.id=ra.release_id
JOIN release_label rl on rl.release_id=r.id
JOIN label l on rl.label_id=l.id
where l.id = 
  (SELECT l.id FROM label l
   JOIN release_label rl on rl.label_id=l.id 
   JOIN release_track rt on rt.release_id=rl.release_id
   WHERE rt.id = 1);


-- An artists labels
SELECT * 
FROM label 
WHERE id = any(SELECT label_id 
              FROM release_label
              WHERE release_id = any(SELECT release_id 
                                    FROM release_artist
                                    WHERE artist_id = 429140));

-- Artist label release count
SELECT * FROM 
  (SELECT l.name label_name, l.id label_id, count(r.id) release_count FROM release r
  INNER JOIN release_artist ra ON r.id = ra.release_id
  INNER JOIN release_label rl ON r.id = rl.release_id
  INNER JOIN label l ON rl.label_id = l.id
  INNER JOIN artist a ON ra.artist_id = a.id
  WHERE a.id = 429140
  GROUP BY l.id) releases
WHERE releases.release_count > 1;

-- Label tracks
SELECT  min(l.name), rt.release_id, rt.id as track_id, string_agg(distinct a.name, ', ') release_artists, string_agg(distinct aa.name, ', ') track_artists, rt.title track_title
FROM release_track rt
LEFT JOIN release_label rl USING(release_id)
LEFT JOIN label l ON rl.label_id = l.id
LEFT JOIN release_track_artist rta ON rt.id = rta.release_track_id
LEFT JOIN release_artist ra ON rt.release_id=ra.release_id
LEFT JOIN artist a ON ra.artist_id = a.id 
LEFT JOIN artist aa ON rta.artist_id = aa.id
WHERE l.id = 8792
GROUP BY track_id;

-- Add tracks to track_queue
