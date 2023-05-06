
CREATE OR REPLACE FUNCTION GetRandomTimestampBetween(
		t1 IN TIMESTAMP,
		t2 IN TIMESTAMP) RETURN TIMESTAMP AS
	t TIMESTAMP;
BEGIN
	SELECT t1 + dbms_random.value(0, 1) * (t2-t1)
		INTO t
		FROM dual;
	RETURN t;
END;

SELECT * FROM SYS.USER_ERRORS;

