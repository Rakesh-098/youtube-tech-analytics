# YouTube Tech Channel Analytics

A project analyzing 300 videos across 6 tech YouTube channels (3 Indian, 3 global) to see what actually drives views and engagement — pulled live from YouTube's own API rather than a downloaded dataset.

## Why I built this

After my first project, I wanted to push myself a bit further — specifically, working with a live API instead of a static CSV. So this one covers the whole thing: authenticating with Google's API, pulling real-time data in Python, cleaning it, analyzing it in SQL and Python, and building a dashboard on top, same workflow as my first project but with a genuinely new skill in the middle.

## Tools

- YouTube Data API v3 – pulling live channel and video data
- Python (Pandas, NumPy, Matplotlib) – cleaning and analysis
- MySQL – business question queries
- Power BI – the dashboard

## About the data

I picked 6 tech review channels — MKBHD, Unbox Therapy, and Linus Tech Tips globally, and Technical Guruji, Trakin Tech, and Geeky Ranjit from India — and pulled their 50 most recent videos each via the API, giving 300 videos total. For each video I collected views, likes, comments, duration, upload date, and tag count.

## What I did

I started by connecting to the YouTube API in Python, fetching each channel's ID and their uploads playlist, then pulling video-level stats in batches (`01_fetch_data.ipynb`). API keys are sensitive, so I kept mine out of the code entirely using a `.env` file and `python-dotenv`, rather than hardcoding it — that file is excluded from this repo via `.gitignore`.

From there I cleaned the data (`02_data_cleaning.ipynb`) — checking for nulls and duplicates, converting the upload dates, and writing a small parser to convert YouTube's duration format (like `PT12M49S`) into actual minutes I could analyze.

I loaded the cleaned data into MySQL and wrote queries (`business_questions.sql`) to compare channels on engagement rate (not just raw views), check whether upload day affects performance, and see how video length relates to views.

Then I went deeper in Python (`03_analysis.ipynb`), checking actual correlations between video length, tag count, and title length against views — not just grouped averages.

Finally I built a Power BI dashboard (`YouTube_Analytics_Dashboard.pbix`) pulling it all together with KPI cards, channel comparisons, and the upload-day and title-length patterns.

## What I found

The most surprising finding was around Unbox Therapy — it gets solid view counts (1.4M average, actually higher than Linus Tech Tips), but its engagement rate is just 0.70%, less than a quarter of every other channel in the set. Linus Tech Tips and MKBHD lead on engagement at 3.18% and 3.03% respectively.

Title length mattered more than I expected. Videos with titles under 40 characters averaged 2.1M views, dropping to 974K for 40-60 characters, and just 289K past 60 characters — a pretty steep, consistent drop-off (correlation of -0.465).

Oddly, videos with more tags tended to get fewer views (correlation of -0.410) — the opposite of what I assumed going in. My guess is that bigger, established channels rely less on tags for discovery and just tag less, while it's smaller/newer videos over-tagging that still underperform, but that's a theory, not something I've confirmed.

Video length had a real but fairly weak negative relationship with views (-0.130) — shorter videos do somewhat better, but it's not a dominant factor on its own. Upload day mattered more clearly: Wednesday videos averaged 1.59M views versus just 430K on Sundays.

## Dashboard

![Dashboard Preview](images/dashboard_preview.png)

## Want to run this yourself?

1. Clone the repo
2. Get your own YouTube Data API key from Google Cloud Console and add it to a `.env` file as `YOUTUBE_API_KEY=your_key`
3. Run `01_fetch_data.ipynb` to pull fresh data
4. Run `02_data_cleaning.ipynb` to clean it
5. Load the cleaned CSV into MySQL and run `business_questions.sql`
6. Run `03_analysis.ipynb` for the deeper analysis
7. Open `YouTube_Analytics_Dashboard.pbix` in Power BI Desktop

## About me

Rakesh Samanta
