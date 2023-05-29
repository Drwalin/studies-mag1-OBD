CREATE OR REPLACE FUNCTION SelectAllItemsInLocationInTimepoint(
		location IN VARCHAR2,
		timepoint IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT I1.item
		FROM SelectAllEntitiesInLocationInTimepoint(location, timepoint) E1
			CROSS JOIN LATERAL
			(SELECT * FROM SelectItemsOfPlayerInTimepoint(E1.name, timepoint)) I1
	}';
END;

SELECT * FROM SYS.USER_ERRORS;


SELECT * FROM SelectAllEntitiesInLocationInTimepoint('Alabama',
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));

SELECT * FROM SelectItemsOfPlayerInTimepoint('William Dennis Meyer',
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));


SELECT * FROM SelectAllItemsInLocationInTimepoint('Alabama',
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));




SELECT I1.item
	FROM SelectAllEntitiesInLocationInTimepoint('Alabama', TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) E1
        CROSS JOIN LATERAL
		(SELECT * FROM SelectItemsOfPlayerInTimepoint(E1.name, TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'))) I1;
	