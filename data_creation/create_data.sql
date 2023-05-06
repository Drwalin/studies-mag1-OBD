
BEGIN
	ClearAllData();
	CreateEntityTypes();
	CreateEntities(10);
	
	CreateLocations();
	
	
	
END;





SELECT * FROM entities;

SELECT * FROM SYS.USER_ERRORS;


SELECT LOCATION_NAME, length(LOCATION_NAME) FROM IMPORTED_LOCATION_NAMES ORDER BY -length(LOCATION_NAME);

