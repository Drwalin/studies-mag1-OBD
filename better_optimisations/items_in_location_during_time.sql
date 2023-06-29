DECLARE
	loc VARCHAR2(64) := 'Alabama';
	timeStart TIMESTAMP := TO_TIMESTAMP('2000-01-01 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6');
	timeEnd TIMESTAMP := TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6');
BEGIN
	SELECT item FROM (
		SELECT item FROM
			(SELECT E1.item
				FROM (SELECT * FROM entities_entered_location l1
					WHERE l1.date_time <= timeEnd
					AND l1.date_time >= timeStart
				) EL1,
				SelectAllItemsInLocationInTimepointOptimised1(loc, EL1.date_time) E1)
			UNION ALL (SELECT DISTINCT E1.item
				FROM (SELECT * FROM transactions 
					WHERE stamp <= timeEnd
					AND stamp >= timeStart) T1,
				SelectAllItemsInLocationInTimepointOptimised1(loc, T1.stamp) E1)
			UNION ALL (SELECT item FROM
				SelectAllItemsInLocationInTimepointOptimised1(loc, timeStart))
			UNION ALL (SELECT item FROM
				SelectAllItemsInLocationInTimepointOptimised1(loc, timeEnd))
		);
END;





CREATE OR REPLACE FUNCTION SelectAllItemsInLocationDuringOptimised(
		loc IN VARCHAR2,
		timeStart IN TIMESTAMP,
		timeEnd IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
 	RETURN q'{
	SELECT * FROM entity_item_receivings i1, entity_in_location l1
		WHERE l1.location = loc
		AND l1.entered < timeEnd
		AND (
			l1.leaved >= timeStart
			OR l1.leaved IS NULL
		)
		AND i1.owner = l1.name
		AND i1.stamp < timeEnd
		AND (
			i1.abandonmentTIme >= timeStart
			OR i1.abandonmentTIme IS NULL
		)
		AND (
			i1.stamp < l1.leaved
			OR l1.leaved IS NULL
		)
		AND (
			i1.abandonmentTIme >= l1.entered
			OR i1.abandonmentTIme IS NULL
		)
 	}';
END;



CREATE OR REPLACE FUNCTION SelectAllItemsInLocationInTimepointTesting(
		location IN VARCHAR2,
		timepoint IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT UNIQUE I1.item
		FROM SelectAllEntitiesInLocationInTimepoint(location, timepoint) E1
			CROSS JOIN LATERAL
			(SELECT * FROM SelectItemsOfPlayerInTimepointUnoptimisedVery(E1.name, timepoint)) I1
	}';
END;
	
CREATE OR REPLACE FUNCTION SelectAllItemsInLocationDuringBetter3(
		loc IN VARCHAR2,
		timeStart IN TIMESTAMP,
		timeEnd IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
 	RETURN q'{
	SELECT DISTINCT item FROM (
		SELECT item FROM
			(SELECT DISTINCT E1.item
				FROM (SELECT * FROM entities_entered_location
					WHERE date_time <= timeEnd
					AND date_time >= timeStart) EL1,
				SelectAllItemsInLocationInTimepointTesting(loc, EL1.date_time) E1)
			UNION ALL (SELECT DISTINCT E1.item
				FROM (SELECT * FROM transactions 
					WHERE stamp <= timeEnd
					AND stamp >= timeStart) T1,
				SelectAllItemsInLocationInTimepointTesting(loc, T1.stamp) E1)
			UNION ALL (SELECT item FROM
				SelectAllItemsInLocationInTimepointTesting(loc, timeStart))
			UNION ALL (SELECT item FROM
				SelectAllItemsInLocationInTimepointTesting(loc, timeEnd))
		)
 	}';
END;
	
SELECT * FROM SelectAllItemsInLocationDuringBetter3('Alabama',
		TO_TIMESTAMP('2000-01-01 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;
	
	
	
	
	

SELECT * FROM SYS.USER_ERRORS;

SELECT item FROM SelectAllItemsInLocationDuringOptimised('Alabama',
		TO_TIMESTAMP('2000-01-01 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;

SELECT * FROM ENTITY_ITEM_RECEIVINGS eir WHERE eir.item = 1095;
SELECT * FROM ENTITY_ITEM_RECEIVINGS eir, ENTITY_IN_LOCATION eil
WHERE eir.item = 1095
AND eir.owner = eil.name 
AND (
	eil.ENTERED <= eir.ABANDONMENTTIME 
	OR eir.ABANDONMENTTIME IS NULL 
	)
AND (
	eil.LEAVED >= eir.stamp
	OR eil.LEAVED IS NULL 
	)
AND eil.LOCATION = 'Alabama'
;

SELECT *
FROM TRANSACTION_ENTRIES te,
	TRANSACTIONS t
--	,ENTITIES_ENTERED_LOCATION eel
WHERE t.id = te.TRANSACTION
AND te.item = 47
ORDER BY t.STAMP;

SELECT item FROM SelectAllItemsInLocationDuringOptimised('Alabama',
		TO_TIMESTAMP('2000-01-01 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;

SELECT * FROM SelectAllItemsInLocationDuringBetter('Alabama',
		TO_TIMESTAMP('2000-01-01 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;

SELECT * FROM SelectAllItemsInLocationDuring('Alabama',
		TO_TIMESTAMP('2000-01-01 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;

SELECT * FROM SelectAllItemsInLocationDuringUnoptimised('Alabama',
		TO_TIMESTAMP('2000-01-01 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;
