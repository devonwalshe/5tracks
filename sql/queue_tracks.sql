--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: queue_tracks; Type: TABLE; Schema: public; Owner: azymuth; Tablespace: 
--

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
    total_rating double precision DEFAULT 0.0 NOT NULL
);


ALTER TABLE public.queue_tracks OWNER TO azymuth;

--
-- Name: queue_tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: azymuth; Tablespace: 
--

ALTER TABLE ONLY queue_tracks
    ADD CONSTRAINT queue_tracks_pkey PRIMARY KEY (id);


--
-- Name: queue_tracks_release_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: azymuth
--

ALTER TABLE ONLY queue_tracks
    ADD CONSTRAINT queue_tracks_release_id_fkey FOREIGN KEY (release_id) REFERENCES release(id);


--
-- Name: queue_tracks_track_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: azymuth
--

ALTER TABLE ONLY queue_tracks
    ADD CONSTRAINT queue_tracks_track_id_fkey FOREIGN KEY (track_id) REFERENCES release_track(id);


--
-- PostgreSQL database dump complete
--

