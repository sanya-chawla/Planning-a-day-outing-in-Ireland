--- Calculating number of vegetarian restaurants in each county.
Alter table irelandcounties add column vegetarianrestaurants_per_county real default 0;

With query as (
	select irelandcounties.id_1,count(*) as num
	from irelandcounties,irelandrestaurants3
	where st_contains(irelandcounties.wkb_geometry,irelandrestaurants3.restaurantgeom) 
	AND irelandrestaurants3.vegetarianfriendly = 'Y'
	group by irelandcounties.id_1 
)
update irelandcounties
set vegetarianrestaurants_per_county = query.num
from query where irelandcounties.id_1=query.id_1;

--- Showing Galway Bay in Map
DROP VIEW IF EXISTS GalwayBay;
CREATE OR REPLACE VIEW GalwayBay
AS
SELECT * from irelandactivities where Name = 'Galway Bay';

--- Restaurants near Galway Bay
DROP VIEW IF EXISTS restaurants_near_galwaybay;
CREATE OR REPLACE VIEW restaurants_near_galwaybay
AS
SELECT *, ST_DISTANCE(ST_TRANSFORM(ST_GEOMFROMTEXT('POINT(-8.919207887 53.27095769)',4326),29902),
			ST_TRANSFORM(restaurantgeom,29902)) as thedistance FROM irelandrestaurants3 where 
ST_DISTANCE(ST_TRANSFORM(ST_GEOMFROMTEXT('POINT(-8.919207887 53.27095769)',4326),29902),
			ST_TRANSFORM(restaurantgeom,29902)) <= 1000 and vegetarianfriendly = 'Y';

--- Selected restaurant near Galway Bay
DROP VIEW IF EXISTS selectedrestaurant_near_galwaybay;
CREATE OR REPLACE VIEW selectedrestaurant_near_galwaybay
AS
SELECT *, 
ST_DISTANCE(ST_TRANSFORM(ST_GEOMFROMTEXT('POINT(-8.919207887 53.27095769)',4326),29902),
			ST_TRANSFORM(restaurantgeom,29902)) as thedistance FROM irelandrestaurants3 where 
ST_DISTANCE(ST_TRANSFORM(ST_GEOMFROMTEXT('POINT(-8.919207887 53.27095769)',4326),29902),
			ST_TRANSFORM(restaurantgeom,29902)) <= 1000			
AND avgrating >= 4.5 and cuisines ~* '^.*italian.*$' and vegetarianfriendly = 'Y' 
ORDER BY excellent desc LIMIT 1;

--- Activity Place
DROP VIEW IF EXISTS kayaking;
CREATE OR REPLACE VIEW kayaking
AS
SELECT *, ST_DISTANCE(ST_TRANSFORM(ST_GEOMFROMTEXT('POINT(-8.92967 53.2685)',4326),29902),
			ST_TRANSFORM(activitygeom,29902)) as thedistance from irelandactivities where 
ST_DISTANCE(ST_TRANSFORM(ST_GEOMFROMTEXT('POINT(-8.92967 53.2685)',4326),29902),
			ST_TRANSFORM(activitygeom,29902)) <= 8000 and tags ~* '^.*kayaking.*$' 
			ORDER BY thedistance asc LIMIT 1;

--- Showing Galway City Museum on map
DROP VIEW IF EXISTS GalwayCityMuseum;
CREATE OR REPLACE VIEW GalwayCityMuseum
AS
SELECT * from irelandactivities where Name = 'Galway City Museum';

--- Restaurants near Galway City Museum
DROP VIEW IF EXISTS restaurants_near_museum;
CREATE OR REPLACE VIEW restaurants_near_museum
AS
SELECT *, ST_DISTANCE(ST_TRANSFORM(ST_GEOMFROMTEXT('POINT(-9.0536151 53.2696822)',4326),29902),
			ST_TRANSFORM(restaurantgeom,29902)) as thedistance FROM irelandrestaurants3 where 
ST_DISTANCE(ST_TRANSFORM(ST_GEOMFROMTEXT('POINT(-9.0536151 53.2696822)',4326),29902),
			ST_TRANSFORM(restaurantgeom,29902)) <= 500 and vegetarianfriendly = 'Y';

--- Selected restaurant near Galway City Museum
DROP VIEW IF EXISTS selectedrestaurant_near_museum;
CREATE OR REPLACE VIEW selectedrestaurant_near_museum
AS		
SELECT *, ST_DISTANCE(ST_TRANSFORM(ST_GEOMFROMTEXT('POINT(-9.0536151 53.2696822)',4326),29902),
			ST_TRANSFORM(restaurantgeom,29902)) as thedistance FROM irelandrestaurants3 where 
ST_DISTANCE(ST_TRANSFORM(ST_GEOMFROMTEXT('POINT(-9.0536151 53.2696822)',4326),29902),
			ST_TRANSFORM(restaurantgeom,29902)) <= 500	and vegetarianfriendly = 'Y'	
AND avgrating >= 4.5 AND cuisines ~* '^.*indian.*$' ORDER BY excellent desc LIMIT 1;
