SELECT
  *
FROM
  BRIGHT_TV.TELEVISION.VIEWERS
LIMIT
  10;

  
SELECT
  *
FROM
  BRIGHT_TV.TELEVISION.VIEWERS_2
LIMIT
  10;



SELECT
    v.userid,        -- User ID
    v.*,            -- All data from VIEWERS
    v2.*            -- All data from VIEWERS_2
FROM
    VIEWERS v
LEFT JOIN
    VIEWERS_2 v2
ON
    v.userid = v2.userid;

DESC TABLE BRIGHT_TV.TELEVISION.VIEWERS;

DESC TABLE BRIGHT_TV.TELEVISION.VIEWERS_2;



-- Select user information
SELECT
    v.USERID AS user_id,
    v.NAME,
    v.SURNAME,
    v.GENDER,
    v.RACE,
    v.AGE,
    v.PROVINCE,

    -- Viewership info from second table
    v2.CHANNEL2 AS channel,
    v2.RECORDDATE2 AS record_date_raw,
    v2.DURATION2 AS duration_raw,

    -- Convert record date string to a timestamp
    TO_TIMESTAMP(v2.RECORDDATE2, 'YYYY/MM/DD HH24:MI') AS record_timestamp,

    -- Convert timestamp to date only
    TO_DATE(TO_TIMESTAMP(v2.RECORDDATE2, 'YYYY/MM/DD HH24:MI')) AS view_date,

    -- Get the name of the day (e.g., Monday, Tuesday)
    DAYNAME(TO_TIMESTAMP(v2.RECORDDATE2, 'YYYY/MM/DD HH24:MI')) AS day_name,

    -- Get the hour of the day (0-23)
    DATE_PART('hour', TO_TIMESTAMP(v2.RECORDDATE2, 'YYYY/MM/DD HH24:MI')) AS hour_of_day,

    -- Check if the day is weekend or weekday
    CASE 
        WHEN DAYOFWEEK(TO_TIMESTAMP(v2.RECORDDATE2, 'YYYY/MM/DD HH24:MI')) IN (1, 7)
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,

    -- Calculate total duration in minutes (hours, minutes, seconds)
    ROUND(
        DATE_PART('hour', v2.DURATION2) * 60 +          -- hours to minutes
        DATE_PART('minute', v2.DURATION2) +             -- minutes
        DATE_PART('second', v2.DURATION2) / 60,          -- seconds to minutes
        2                                              -- round to 2 decimal places
    ) AS duration_minutes,

    -- Group ages into categories
    CASE
        WHEN v.AGE IS NULL THEN 'Unknown'
        WHEN v.AGE < 18 THEN 'Under 18'
        WHEN v.AGE BETWEEN 18 AND 24 THEN '18-24'
        WHEN v.AGE BETWEEN 25 AND 34 THEN '25-34'
        WHEN v.AGE BETWEEN 35 AND 44 THEN '35-44'
        WHEN v.AGE BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,

    -- Categorize session duration
    CASE
        WHEN DATE_PART('second', v2.DURATION2) < 600 THEN 'Short (<10 min)'
        WHEN DATE_PART('second', v2.DURATION2) < 1800 THEN 'Medium (10-30 min)'
        ELSE 'Long (>30 min)'
    END AS session_category

FROM
    BRIGHT_TV.TELEVISION.VIEWERS v
LEFT JOIN
    BRIGHT_TV.TELEVISION.VIEWERS_2 v2
    ON v.USERID = v2.USERID;
