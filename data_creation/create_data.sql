
--- alter session set nls_timestamp_format='YYYY-MM-DD HH24:MI:SS.FF6';
--- alter session set nls_date_format='YYYY-MM-DD';




BEGIN
	ClearAllData();
	CreateEntityTypes();
	CreateItemCategories();
	CreateLocations();
END;

BEGIN
	CreateEntities(100);
END;

BEGIN
	FillEnterLocationsForAll(TO_DATE('2000-01-01', 'YYYY-MM-DD'), 1, 120, 1, 30);
END;

BEGIN
	CreateItems(
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		1,
		500,
		0,
		0,
		0.1,
		0.1
	);
END;

BEGIN
	CreateItems(
		GetDateOfNewestTransaction(),
		50,
		10,
		20,
		10,
		10.0,
		1.0
	);
END;


BEGIN
	ClearAllData();
	CreateEntityTypes();
	CreateItemCategories();
	CreateLocations();
	
	CreateEntities(100);
	FillEnterLocationsForAll(TO_DATE('2000-01-01', 'YYYY-MM-DD'), 1, 120, 1, 30);
	CreateItems(
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		1,
		500,
		0,
		0,
		0.1,
		0.1
	);
	
	CreateItems(
		GetDateOfNewestTransaction(),
		50,
		10,
		20,
		10,
		10.0,
		1.0
	);
END;



SELECT * FROM LOCATIONS;
SELECT count(*) FROM ENTITIES;
SELECT * FROM ENTITIES_ENTERED_LOCATION;
SELECT * FROM ITEMS;
SELECT * FROM TRANSACTION_ENTRIES;
SELECT * FROM TRANSACTIONS;
SELECT * FROM TEMP_ITEM_OWNERSHIP;



SELECT * FROM SYS.USER_ERRORS;


SELECT LOCATION_NAME, length(LOCATION_NAME) FROM IMPORTED_LOCATION_NAMES ORDER BY -length(LOCATION_NAME);

