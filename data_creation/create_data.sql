
--- alter session set nls_timestamp_format='YYYY-MM-DD HH24:MI:SS.FF6';
--- alter session set nls_date_format='YYYY-MM-DD';


BEGIN
	ClearAllData();
END;
	
BEGIN
	CreateEntityTypes();
END;

BEGIN
	CreateEntities(100);
END;

BEGIN
	CreateLocations();
END;

BEGIN
	FillEnterLocationsForAll(TO_DATE('2000-01-01', 'YYYY-MM-DD'), 1, 120, 1, 30);
END;

BEGIN
-- 	CreateItems(1000);
END;


BEGIN
	ClearAllData();
	CreateEntityTypes();
	CreateEntities(100);
	CreateLocations();
	FillEnterLocationsForAll(TO_DATE('2000-01-01', 'YYYY-MM-DD'), 1, 120, 1, 30);
END;



SELECT * FROM LOCATIONS;
SELECT count(*) FROM ENTITIES;
SELECT * FROM ENTITIES_ENTERED_LOCATION;


SELECT * FROM SYS.USER_ERRORS;


SELECT LOCATION_NAME, length(LOCATION_NAME) FROM IMPORTED_LOCATION_NAMES ORDER BY -length(LOCATION_NAME);

