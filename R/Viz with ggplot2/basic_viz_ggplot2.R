
library(ggplot2)



data <- read.csv('sample-data-for-r-plot3.txt')

# Init graph
ggplot(data, aes(Year, Number)) +
  geom_point()

# Change the shape
ggplot(data, aes(Year, Number)) +
  geom_point(aes(shape = Sex))

# Change the color
ggplot(data, aes(Year, Number)) +
  geom_point(aes(shape = Sex, color = State))

# Change size
ggplot(data, aes(Year, Number)) +
  geom_point(aes(shape = Sex, color = State, size = Sex))

# Too crowded -> create facets | Nhieu khia canh
ggplot(data, aes(Year, Number)) +
  geom_point(aes(shape = Sex, color = State)) +
  facet_wrap(~Sex)

# Draw differemt facets in 1 row
ggplot(data, aes(Year, Number)) +
  geom_point(aes(shape = Sex)) +
  facet_wrap(~State, nrow = 1)

# Look at 2 facets
ggplot(data, aes(Year, Number)) +
  geom_point() +
  facet_grid(Sex ~ State)

# Change to bars
ggplot(data, aes(Year, Number)) +
  geom_bar(stat = "identity") +
  facet_grid(Sex ~ State)



# -------------------------------------------- #
#           Viz Economics Long
# -------------------------------------------- #

library(dplyr)

data <- economics_long
glimpse(data)

ggplot(data, aes(x=date, y=value01, color=variable)) +
  geom_line()








