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



