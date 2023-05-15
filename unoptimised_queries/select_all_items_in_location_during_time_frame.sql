
-- select all items that were in location during given time frame

CREATE OR REPLACE TYPE t_ints AS TABLE OF INT;

-- query plan:


CREATE OR REPLACE FUNCTION SelectAllItemsInLocationDuring(
		locationn IN VARCHAR2,
		timeStart IN TIMESTAMP,
		timeEnd IN TIMESTAMP
) RETURN t_ints AS
	ret t_ints;
BEGIN
	SELECT name BULK COLLECT INTO ret
		FROM items I1
		WHERE
		WHERE E1.location = locationn AND E1.date_time <= timepoint
		AND
		(SELECT count(*) FROM entities_entered_location E2
			WHERE E2.location = locationn
			AND E2.name = E1.name
			AND E2.date_time > E1.date_time
			AND E2.date_time <= timepoint
		) = 0
		GROUP BY E1.name;
	RETURN ret;
END;






