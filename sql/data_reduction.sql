-- We are looking for all relations that don't have aa master


-- How may releases don't have a master? - ~4m
-- select count(*) from release where master_id is null;

-- How many releases have a master? - ~5.2m
-- select count(*) from release where master_id is not null;

-- How many releases have unique masters - ~1.2m
-- select count(distinct(master_id)) from release where master_id is not null;

-- Select releases where id is not in distict master records original release_id or 

  
-- send to intermediary table
SELECT * INTO release_reduced FROM (
  (SELECT * from release where master_id is NULL)
  UNION 
  (SELECT * FROM release
   WHERE id = any(select distinct(main_release) from master))) r;

ALTER TABLE release_reduced ADD PRIMARY KEY (id);

--  Second intermediary table for records to delete
SELECT id INTO release_delete 
FROM release r 
WHERE NOT EXISTS 
  (SELECT * FROM release_reduced rr 
   WHERE r.id=rr.id)

-- CASCADING DELETE
DELETE FROM release 
WHERE id = any(array(SELECT id FROM release_delete));

VACUUM verbose;

DROP TABLE release_reduced;

DROP TABLE release_delete;
      
      