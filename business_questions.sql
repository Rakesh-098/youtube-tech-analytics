CREATE TABLE youtube_analytics_db.videos (
    video_id VARCHAR(20),
    channel_name VARCHAR(100),
    title VARCHAR(500),
    published_at DATETIME,
    duration VARCHAR(20),
    view_count BIGINT,
    like_count BIGINT,
    comment_count BIGINT,
    tags_count INT,
    upload_year INT,
    upload_month INT,
    upload_day_of_week VARCHAR(20),
    duration_seconds INT,
    duration_minutes DECIMAL(10,2)
);
SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'D:/Youtube API/youtube-tech-analytics/cleaned_data/youtube_tech_channels_cleaned.csv'
INTO TABLE youtube_analytics_db.videos
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM youtube_analytics_db.videos;
SELECT channel_name,
       ROUND(AVG(view_count), 0) AS avg_views,
       ROUND(AVG(like_count), 0) AS avg_likes,
       ROUND(AVG(like_count) / AVG(view_count) * 100, 2) AS engagement_rate_pct
FROM youtube_analytics_db.videos
GROUP BY channel_name
ORDER BY engagement_rate_pct DESC;
SELECT upload_day_of_week,
       COUNT(*) AS videos_uploaded,
       ROUND(AVG(view_count), 0) AS avg_views
FROM youtube_analytics_db.videos
GROUP BY upload_day_of_week
ORDER BY avg_views DESC;
SELECT 
    CASE 
        WHEN duration_minutes < 5 THEN 'Short (<5 min)'
        WHEN duration_minutes BETWEEN 5 AND 15 THEN 'Medium (5-15 min)'
        ELSE 'Long (15+ min)'
    END AS length_category,
    COUNT(*) AS video_count,
    ROUND(AVG(view_count), 0) AS avg_views
FROM youtube_analytics_db.videos
GROUP BY length_category
ORDER BY avg_views DESC;
SELECT channel_name, title, view_count, video_rank
FROM (
    SELECT channel_name, title, view_count,
           RANK() OVER (PARTITION BY channel_name ORDER BY view_count DESC) AS video_rank
    FROM youtube_analytics_db.videos
) ranked
WHERE video_rank <= 3
ORDER BY channel_name, video_rank;