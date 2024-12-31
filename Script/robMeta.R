install.packages("robvis")   # Jika belum diinstal
library(robvis)

my_rob_data <- read.csv(file.choose(), header = TRUE)

rob_barplot <- rob_summary(data = my_rob_data, tool = "ROB2")
print(rob_barplot)

rob_traffic <- rob_traffic_light(data = my_rob_data, tool = "ROB2")
print(rob_traffic)
