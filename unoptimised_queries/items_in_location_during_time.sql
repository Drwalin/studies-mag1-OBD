CREATE OR REPLACE FUNCTION SelectAllItemsInLocationDuringBetter(
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
				SelectAllItemsInLocationInTimepoint(loc, EL1.date_time) E1)
			UNION ALL (SELECT DISTINCT E1.item
				FROM (SELECT * FROM transactions 
					WHERE stamp <= timeEnd
					AND stamp >= timeStart) T1,
				SelectAllItemsInLocationInTimepoint(loc, T1.stamp) E1)
			UNION ALL (SELECT item FROM
				SelectAllItemsInLocationInTimepoint(loc, timeStart))
			UNION ALL (SELECT item FROM
				SelectAllItemsInLocationInTimepoint(loc, timeEnd))
		)
 	}';
END;

CREATE OR REPLACE FUNCTION SelectAllItemsInLocationDuring(
		loc IN VARCHAR2,
		timeStart IN TIMESTAMP,
		timeEnd IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
 	RETURN q'{
	SELECT DISTINCT item FROM (
		SELECT item FROM
			(SELECT DISTINCT E1.item
				FROM entities_entered_location EL1,
					SelectAllItemsInLocationInTimepoint(loc, EL1.date_time) E1
				WHERE EL1.date_time <= timeEnd
				AND EL1.date_time >= timeStart)dbea
			UNION ALL (SELECT DISTINCT E1.item
				FROM transactions T1,
					SelectAllItemsInLocationInTimepoint(loc, T1.stamp) E1
				WHERE T1.stamp <= timeEnd
				AND T1.stamp >= timeStart)
			UNION ALL (SELECT item FROM
				SelectAllItemsInLocationInTimepoint(loc, timeStart))
			UNION ALL (SELECT item FROM
				SelectAllItemsInLocationInTimepoint(loc, timeEnd))
		)
 	}';
END;

CREATE OR REPLACE FUNCTION SelectAllItemsInLocationDuringUnoptimised(
		loc IN VARCHAR2,
		timeStart IN TIMESTAMP,
		timeEnd IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
 	RETURN q'{
	SELECT DISTINCT item FROM (
		SELECT item FROM
			(SELECT DISTINCT E1.item
				FROM entities_entered_location EL1 CROSS JOIN LATERAL
					(SELECT * FROM
						SelectAllItemsInLocationInTimepoint(loc, EL1.date_time)) E1
				WHERE EL1.date_time <= timeEnd
				AND EL1.date_time >= timeStart)
			UNION ALL (SELECT DISTINCT E1.item
				FROM transactions T1 CROSS JOIN LATERAL
					(SELECT * FROM SelectAllItemsInLocationInTimepoint(loc, T1.stamp)) E1
				WHERE T1.stamp <= timeEnd
				AND T1.stamp >= timeStart)
			UNION ALL (SELECT item FROM
				SelectAllItemsInLocationInTimepoint(loc, timeStart))
			UNION ALL (SELECT item FROM
				SelectAllItemsInLocationInTimepoint(loc, timeEnd))
		)
 	}';
END;

SELECT * FROM SYS.USER_ERRORS;

SELECT * FROM SelectAllItemsInLocationDuringBetter('Alabama',
		TO_TIMESTAMP('2000-01-01 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));

SELECT * FROM SelectAllItemsInLocationDuring('Alabama',
		TO_TIMESTAMP('2000-01-01 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));

SELECT * FROM SelectAllItemsInLocationDuringUnoptimised('Alabama',
		TO_TIMESTAMP('2000-01-01 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));
	
	




