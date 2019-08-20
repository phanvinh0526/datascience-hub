
##############################################################
##  R-Learning Introduction to ggplots (Data Visualization) ##
##############################################################

library(ggplot2)



##### plot a basic graph

options(scipen = 1000000)
docklands <- melbourne_housing %>%
  filter(suburb == "Docklands") %>%
  filter(!is.na(price))

mel_city_council <- melbourne_housing %>%
  inner_join(suburb_data, by = 'suburb') %>%
  filter(str_detect(council_area, 'Melbourne City Council')) %>%
  mutate(dt = dmy(dt)) %>%
  mutate(yr = year(dt))

mel_city_price <- mel_city_council %>%
  group_by(suburb, yr) %>%
  summarise(median_house_price = median(price, na.rm=TRUE))
  


plot(docklands$rooms, docklands$price)

### change data point shape (black color)
ggplot(docklands) +
  geom_point(aes(x = rooms, y = price, color="blue"))


### Histogram
ggplot(mel_city_council) +
  geom_histogram(aes(x = price)) +
  labs(x = "Price",
       y = "Number of properties")


### Boxplot
ggplot(mel_city_council) +
  geom_boxplot(aes(x = suburb, y = price, fill = suburb)) +
  labs( x = 'Suburb', y = 'Price')


### Line Plot | price trend
ggplot(mel_city_price) +
  geom_line(aes(x = yr, y = median_house_price, 
            group = suburb, colour = suburb)) +
  labs(x = 'Year', y = 'Median Price', title = 'Price Trend')
  # fill : fill color to a bar (hinh tru), colour : color lines


### Custom colour

ggplot(mel_city_council) +
  geom_boxplot(aes(x = suburb, y = price, fill = suburb)) +
  labs( x = 'Suburb', y = 'Price') +
  scale_fill_brewer(palette = "Paired")


### Custom Zoom

ggplot(mel_city_council) +
  geom_boxplot(aes(x = suburb, y = price, fill = suburb)) +
  labs( x = 'Suburb', y = 'Price') +
  scale_fill_brewer(palette = "Paired") +
  coord_cartesian(ylim = c(0, 3000000))



