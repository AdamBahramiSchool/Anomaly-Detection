wd <- getwd()
setwd(wd)
library(zoo)
library(dplyr)
library(ggplot2)

# Function to find the most and least anomalous weeks
find_anomalous_weeks <- function(difference_data) {
  max_difference_week <- difference_data %>%
    filter(AverageDifference == max(AverageDifference))
  min_difference_week <- difference_data %>%
    filter(AverageDifference == min(AverageDifference))
  
  list(max = max_difference_week, min = min_difference_week)
}


data_frame <- read.delim('Group_Assignment_Dataset.txt', sep = ",")

# Parse the date to get a POSIXlt time object
data_frame$Date <- strptime(paste(data_frame$Date, data_frame$Time), "%d/%m/%Y %H:%M:%S")

# Extract the day and week of the year
data_frame <- data_frame %>%
  mutate(DayOfYear = Date$yday,
         DayTime = paste(weekdays(Date), Time),
         WeekOfYear = floor(Date$yday / 7) + 1)
data_frame <- data_frame %>%
  group_by(WeekOfYear) %>%
  mutate(MovingAverage = rollmean(Global_intensity, k = 7, align = "right", fill = NA))

# Get the average moving average at every time point
average_smoothed_week <- data_frame %>%
  group_by(DayTime) %>%
  summarise(MovingAverage = mean(MovingAverage, na.rm = TRUE))

# Create a time series object for the average smoothed week
average_smoothed_week_ts <- zoo::zoo(average_smoothed_week$MovingAverage, order.by = average_smoothed_week$DayTime)

# Calculate the difference between the moving average for each week and the average smoothed week
difference_data <- data_frame %>%
  group_by(WeekOfYear) %>%
  summarise(AverageDifference = mean(abs(MovingAverage - average_smoothed_week_ts), na.rm = TRUE))
anomalous_weeks <- find_anomalous_weeks(difference_data)
average_smoothed_week$WeekOfYear <- 0
most_different_week <- data_frame[data_frame$WeekOfYear == anomalous_weeks$max$WeekOfYear,]
least_different_week <- data_frame[data_frame$WeekOfYear == anomalous_weeks$min$WeekOfYear,]
selected_weeks <- bind_rows(average_smoothed_week, most_different_week, least_different_week)

# Plotting the most and least anomalous weeks against the average smoothed week
difference_plot <- ggplot(selected_weeks, aes(x = DayTime, y = MovingAverage, group = WeekOfYear, colour = factor(WeekOfYear))) +
  geom_line() + 
  scale_color_manual(values = c("green", "purple", "orange"), labels = c("Average Week", "Most Anomalous Week", "Least Anomalous Week")) +
  labs(
    title = "Comparison of Anomalous Weeks to the Average Week",
    x = "Time",
    y = "Moving Average",
    color = "Week of Year"
  )

# Save the plot to a PDF file
ggsave("AnomalousWeeksComparison.pdf", plot = difference_plot, device = "pdf")
