
--- alter session set nls_timestamp_format='YYYY-MM-DD HH24:MI:SS.FF6';
--- alter session set nls_date_format='YYYY-MM-DD';



ALTER TABLE entities_entered_location MODIFY(ID GENERATED AS IDENTITY (START WITH 1));
ALTER TABLE transaction_entries MODIFY(ID GENERATED AS IDENTITY (START WITH 1));
ALTER TABLE transactions MODIFY(ID GENERATED AS IDENTITY (START WITH 1));
ALTER TABLE items MODIFY(ID GENERATED AS IDENTITY (START WITH 1));

BEGIN
	ClearAllData();
END;


BEGIN
	ClearAllData();
	CreateEntityTypes();
	CreateItemCategories();
	CreateLocations();
END;

BEGIN
	CreateEntities(1000);
END;

BEGIN
	FillEnterLocationsForAll(TO_DATE('2000-01-01', 'YYYY-MM-DD'), 1, 120, 1, 30);
END;

BEGIN
	CreateItems(
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		50,
		100,
		0,
		0,
		0.1,
		0.1
	);
END;

BEGIN
	CreateItems(
		GetDateOfNewestTransaction(),
		100,
		100,
		100,
		100,
		10.0,
		1.0
	);
END;





BEGIN
	ClearAllData();
	
	CreateEntityTypes();
	CreateEntities(100);
	
	CreateLocations();
	FillEnterLocationsForAll(TO_DATE('2000-01-01', 'YYYY-MM-DD'), 1, 120, 1, 30);
	
	CreateItemCategories();
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






BEGIN
	ClearAllData();
	CreateEntityTypes();
	CreateItemCategories();
	CreateLocations();
	
	CreateEntities(5);
	FillEnterLocationsForAll(TO_DATE('2000-01-01', 'YYYY-MM-DD'), 1, 120, 1, 5);
	CreateItems(
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		1,
		30,
		0,
		0,
		1.0,
		1.0
	);
	
	CreateItems(
		GetDateOfNewestTransaction(),
		10,
		0,
		10,
		10,
		10.0,
		1.0
	);
END;




SELECT
		CASE
			WHEN te.from_a = 1 THEN t.owner_a
			ELSE t.owner_b
		END AS sourceName,
		CASE
			WHEN te.from_a = 1 THEN t.owner_b
			ELSE t.owner_a
		END AS destinyName,
		te.ID,
		te."TRANSACTION" ,
		te.ITEM,
		te.FROM_A,
		t.STAMP,
		t.OWNER_A ,
		t.OWNER_B 
	FROM TRANSACTION_ENTRIES te
		JOIN TRANSACTIONS t
			ON t.ID = te.TRANSACTION
	ORDER BY te.item ASC, t.stamp ASC;




SELECT * FROM LOCATIONS;
SELECT count(*) FROM ENTITIES;
SELECT * FROM ENTITIES_ENTERED_LOCATION t ORDER BY t.DATE_TIME DESC;
SELECT * FROM ITEMS;
SELECT * FROM TRANSACTION_ENTRIES;
SELECT * FROM TRANSACTIONS;
SELECT * FROM TEMP_ITEM_OWNERSHIP;



SELECT * FROM SYS.USER_ERRORS;


SELECT LOCATION_NAME, length(LOCATION_NAME) FROM IMPORTED_LOCATION_NAMES ORDER BY -length(LOCATION_NAME);

