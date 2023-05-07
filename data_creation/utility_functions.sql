

CREATE OR REPLACE FUNCTION AdvanceTimestamp(
		currentTime TIMESTAMP,
		hours_min IN NUMBER,
		hours_max IN NUMBER) RETURN TIMESTAMP IS
BEGIN
	RETURN currentTime + dbms_random.value(hours_min, hours_max) * INTERVAL '1' HOUR;
END;


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


CREATE OR REPLACE FUNCTION RandomGaussian(
		minx IN NUMBER,
		maxx IN NUMBER) RETURN NUMBER AS
BEGIN
	RETURN dbms_random.value(minx/3, maxx/3)
		+ dbms_random.value(minx/3, maxx/3)
		+ dbms_random.value(minx/3, maxx/3);
END;


CREATE OR REPLACE FUNCTION GetDateOfNewestTransaction RETURN TIMESTAMP IS
	ret TIMESTAMP;
BEGIN
	SELECT stamp INTO ret FROM transactions
		ORDER BY stamp DESC FETCH FIRST 1 ROWS ONLY;
	RETURN ret;
END;


SELECT * FROM SYS.USER_ERRORS;


