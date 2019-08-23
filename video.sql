-- describe table in postgres lingo
SELECT *
FROM information_schema.columns
WHERE table_name = 'video';


-- first tinkering in postgres
SELECT title, final_position, duration, name Dversion, disabled FROM public.video
JOIN video_session
	ON video.id = video_session.video_id
JOIN version
	ON deactivated_version_id = version.id
WHERE duration != 0 and final_position > 5 and disabled = false;

SELECT to_char(AVG(final_position), '99999999999999999D99') AS Average_duration
FROM video_session
WHERE duration != 0 and final_position > 5;

SELECT distinct(title), duration, name, disabled
FROM video
Join video_session
	ON video.id = video_session.video_id
JOIN version
	ON video.effective_version_id = version.id
WHERE duration != 0 and duration < 60;

SELECT distinct(title), duration, name, disabled
FROM video
Join video_session
	ON video.id = video_session.video_id
JOIN version
	ON video.effective_version_id = version.id
WHERE duration != 0 and duration < 60 and duration > 10 and name LIKE 'E.14%';


-- active videos with view in title
SELECT distinct(title) AS Video_Title, name AS dVersion

active videos with view in title
FROM video
Join video_session
	ON video.id = video_session.video_id
LEFT JOIN version
	ON video.deactivated_version_id = version.id

	
WHERE duration != 0 and duration > 10 and name is null and title LIKE 'View%';

-- all active videos with final position
SELECT title, deactivated_version_id, final_position, duration, name Dversion, disabled FROM public.video
JOIN video_session
	ON video.id = video_session.video_id
JOIN version
	ON effective_version_id = version.id
WHERE duration != 0 and final_position > 5 and deactivated_version_id is null and final_position <= duration;


-- joining to version table twice
SELECT title, deactivated_version_id, final_position, duration, name Eversion, disabled FROM public.video
JOIN video_session
	ON video.id = video_session.video_id
JOIN version v1
	ON effective_version_id = v1.id
JOIN version v2
	ON deactivated_version_id = v2.id

WHERE duration != 0 and duration between 180 and 240 and final_position > 5 and deactivated_version_id is null;

--working double join to version
SELECT title, deactivated_version_id, final_position, duration, v1.name Eversion, v2.name Dversion FROM public.video
JOIN video_session
	ON video.id = video_session.video_id
JOIN version v1
	ON effective_version_id = v1.id
LEFT JOIN version v2
	ON deactivated_version_id = v2.id
WHERE duration != 0 and duration between 180 and 240 and final_position > 5;

--distinct on title.
SELECT distinct on(title) title, deactivated_version_id, duration, v1.name Eversion, v2.name Dversion FROM public.video
JOIN video_session
	ON video.id = video_session.video_id
JOIN version v1
	ON effective_version_id = v1.id
LEFT JOIN version v2
	ON deactivated_version_id = v2.id

WHERE duration != 0 and duration between 660 and 1200 and final_position > 5;

---count total views by duration length
SELECT Count(*) FROM public.video_session
WHERE duration between 660 and 720;

--view counts for all video durations
SELECT 
SUM(
	CASE
	WHEN duration < 60 THEN 
		1
	ELSE 
		0
	END
)	AS "<1Min",
SUM(
	CASE
	WHEN duration between 60 and 120 THEN 
		1
	ELSE 
		0
	END
)	AS "1-2Min",
SUM(
	CASE
	WHEN duration between 121 and 180 THEN 
		1
	ELSE 
		0
	END
)	AS "2-3Min",
SUM(
	CASE
	WHEN duration between 181 and 240 THEN 
		1
	ELSE 
		0
	END
)	AS "3-4Min",
SUM(
	CASE
	WHEN duration between 241 and 300 THEN 
		1
	ELSE 
		0
	END
)	AS "4-5Min",
SUM(
	CASE
	WHEN duration between 301 and 360 THEN 
		1
	ELSE 
		0
	END
)	AS "5-6Min",
SUM(
	CASE
	WHEN duration between 361 and 420 THEN 
		1
	ELSE 
		0
	END
)	AS "6-7Min",
SUM(
	CASE
	WHEN duration between 421 and 480 THEN 
		1
	ELSE 
		0
	END
)	AS "7-8Min",
SUM(
	CASE
	WHEN duration between 481 and 960 THEN 
		1
	ELSE 
		0
	END
)	AS ">8Min"
	
	FROM public.video_session
WHERE duration != 0 and final_position > 5 and final_position <= duration;

-- All distinct state videos
SELECT distinct on(title) title, ccms_id, deactivated_version_id FROM public.video
JOIN video_session
	ON video.id = video_session.video_id

LEFT JOIN version 
	ON deactivated_version_id = version.id
WHERE (ccms_id like 'MN%' or ccms_id like 'AZ%' or ccms_id like 'CA.%' or ccms_id like 'CO%'
or ccms_id like 'CT%' or ccms_id like 'DC%' or ccms_id like 'FL%' or ccms_id like 'GA%' or ccms_id like 'HI%' or ccms_id like 'IA%' 
or ccms_id like 'ID%' or ccms_id like 'IL%' or ccms_id like 'IN%' or  ccms_id like 'KS%' or ccms_id like 'KY%' or ccms_id like 'LA%'
or ccms_id like 'MA%' or ccms_id like 'MD%' or ccms_id like 'ME%' or ccms_id like 'MI%' or ccms_id like 'MO%' or ccms_id like 'MT%'
or ccms_id like 'NE%' or ccms_id like 'NH%' or ccms_id like 'NJ%' or ccms_id like 'NM%' or ccms_id like 'NV%' or ccms_id like 'NY%'
or ccms_id like 'OH%' or ccms_id like 'OK%' or ccms_id like 'PA.%' or ccms_id like 'RI%' or ccms_id like 'SD%' or ccms_id like 'TN%'
or ccms_id like 'TX%' or ccms_id like 'VA%' or ccms_id like 'VT%' or ccms_id like 'WA%' or ccms_id like 'WI%' or ccms_id like 'WY%')
and deactivated_version_id is null;

-- All distinct state videos using the similar to method instead of like.
SELECT distinct on(video.id)video.id, title, ccms_id, deactivated_version_id FROM public.video
JOIN video_session
    ON video.id = video_session.video_id
Left JOIN version 
    ON deactivated_version_id = version.id
WHERE ccms_id similar to 
'(MN.|AZ.|CA.|CO.|CT.|DC.|FL.|GA.|HI.|IA. ID.|IL.|IN.|KS.|KY.|LA.|MA.|MD.|ME.|MI.|MO.|MT.|NE.|NH.|NJ.|NM.|NV.|NY.|OH.|OK.|PA.|RI.|SD.|TN.|TX.|VA.|VT.|WA.|WI.|WY.)%'
and deactivated_version_id is null;

select count(*) from video where ccms_id similar to 
'(MN.|AZ.|CA.|CO.|CT.|DC.|FL.|GA.|HI.|IA. ID.|IL.|IN.|KS.|KY.|LA.|MA.|MD.|ME.|MI.|MO.|MT.|NE.|NH.|NJ.|NM.|NV.|NY.|OH.|OK.|PA.|RI.|SD.|TN.|TX.|VA.|VT.|WA.|WI.|WY.)%';

-- Count video views by state.
SELECT count(*),
     state
FROM
     (
           SELECT substring(v.ccms_id, 0, 3) AS state
           FROM video v
           JOIN video_session vs ON v.id=vs.video_id
           WHERE v.ccms_id SIMILAR TO '(MN.|AZ.|CA.|CO.|CT.|DC.|FL.|GA.|HI.|IA.|ID.|
IL.|IN.|KS.|KY.|LA.|MA.|MD.|ME.|MI.|MO.|MT.|NE.|NH.|NJ.|NM.|NV.|NY.|OH.|OK.|PA.|RI.|SD.|TN.|TX.|VA.|VT.|WA.|WI.|WY.)%'
      AND vs.duration != 0) AS states 
GROUP BY state
ORDER BY state;
-- Count video view by state
SELECT 
SUM(
	CASE
	WHEN ccms_id like 'MN%' THEN 
		1
	ELSE 
		0
	END
)	AS "MN",
SUM(
	CASE
	WHEN ccms_id like 'OH%' THEN 
		1
	ELSE 
		0
	END
)	AS "OH",
SUM(
	CASE
	WHEN ccms_id like 'AZ%' THEN 
		1
	ELSE 
		0
	END
)	AS "AZ",
SUM(
	CASE
	WHEN ccms_id like 'CA.%' THEN 
		1
	ELSE 
		0
	END
)	AS "CA",
SUM(
	CASE
	WHEN ccms_id like 'KY.%' THEN 
		1
	ELSE 
		0
	END
)	AS "KY"
FROM public.video
JOIN video_session
	ON video.id = video_session.video_id

LEFT JOIN version 
	ON deactivated_version_id = version.id
WHERE duration != 0 and deactivated_version_id is null;