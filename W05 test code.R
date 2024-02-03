# library statements will trigger installation
# Note that dplyr and ggplot2 should be installed from previous workshops, only QCA is new
library(dplyr)
library(ggplot2)
library(QCA)

# test dplyr - should produce table
irisSummary <- iris %>% 
  group_by(Species) %>% 
  summarise(plants = n())
irisSummary

# test ggplot - should produce scatter plot
ggplot(iris, aes(x = Petal.Length, y = Petal.Width)) +
  geom_point()

# test QCA package - produce truth table
ttProtest <- truthTable(CVF, "PROTEST")
ttProtest