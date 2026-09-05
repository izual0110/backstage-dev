CREATE USER backstage WITH PASSWORD 'backstage';
CREATE DATABASE backstage OWNER backstage;

CREATE USER gitlab WITH PASSWORD 'gitlab';
CREATE DATABASE gitlabhq_production OWNER gitlab;
