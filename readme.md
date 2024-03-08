## Task Description
The task involves preprocessing a dataset by slicing it into complete weeks (Monday-Sunday), applying moving averages on the `Global_intensity` variable, and creating a new time series representing the average smoothed week. Additionally, the most and least anomalous weeks among the smoothed weeks are identified by comparing them to the average smoothed week.

## Code Overview
The provided R script accomplishes the following tasks:

1. **Data Preprocessing**: Reads the dataset and parses dates.
2. **Computing Moving Averages**: Calculates the moving average for each complete week using a fixed window size.
3. **Creating Average Smoothed Week**: Computes the average value of all observations over each smoothed week.
4. **Identifying Anomalous Weeks**: Ranks all weeks based on their deviation from the average smoothed week.
5. **Visualizing Results**: Plots the most and least anomalous weeks against the average smoothed week.

## Packages Used
The following R packages were utilized for this assignment:

- `zoo`: Used for time series manipulation, particularly for computing rolling means.
- `dplyr`: Used for data manipulation and summarization.
- `ggplot2`: Utilized for creating visualizations.

## Cybersecurity Relevance
Anomaly detection in time series data is crucial in cybersecurity for identifying unusual patterns or behaviors in network traffic, system logs, or user activities. By detecting anomalies, potential security threats such as intrusion attempts, malware infections, or data breaches can be identified and mitigated in real-time, enhancing overall cybersecurity posture.

## How to Run
1. Ensure you have R installed on your system.
2. Install the required packages (`zoo`, `dplyr`, `ggplot2`) if not already installed.
3. Place the provided R script and dataset (`Group_Assignment_Dataset.txt`) in the same directory.
4. Run the R script to execute the code and generate the output.
5. Check the generated `AnomalousWeeksComparison.pdf` for visual representation of the most and least anomalous weeks.
