
###########################################################
##  R-Learning Introduction to dplyr (Data Manipulation) ##
###########################################################

library(tidyverse);
library(lubridate);
library(dplyr); # already installed in tidyverse
library(geosphere);


##### Loading datasets
melbourne_housing <- read_csv('./melbourne_housing_market.csv');

suburb_data <- read_csv('./suburb_data.csv');

summary(melbourne_housing);

glimpse(melbourne_housing);

glimpse(suburb_data);

head(melbourne_housing, 3);



##### Let do some queries with dplyr

## check attributes
glimpse(melbourne_housing)

## select statement
melbourne_housing %>% select(address, suburb);

## filter statement
melbourne_housing %>% filter(suburb == 'Southbank')

melbourne_housing %>% filter(suburb == 'Mount Waverley' & rooms >= 3 & price <= 1000000)

melbourne_housing %>% filter(suburb %in% c('Southbank', 'Mount Waverley') & rooms >= 5)

  # partial matching
melbourne_housing %>% filter(str_detect(suburb, 'Southb'))


## arrange / sort by columns
melbourne_housing %>% 
  filter(suburb == 'Mount Waverley' & rooms >= 3 & price <= 1000000) %>%
  arrange(desc(rooms), (price))

## Rename columns
melbourne_housing %>%
  select(address, suburb) %>%
  rename(suburb_name = suburb)


## Mutate to create new columns or variables
melbourne_housing %>%
  filter(suburb == 'Toorak' & price >= 1000000) %>%
  select(address, suburb, price) %>%
  mutate(price_in_millions = price / 1000000)


##### Let do some grouping with dplyr

## summarise to reduce multiple values (count, mean / avg, max, min, ....)
  #   n() : counting, n_distinct() : count distinct, sumn() : sum, 
  #   mean() : avg, median() : median of a variable
melbourne_housing %>%
  group_by(suburb) %>%
  summarise(mean_price = mean(price, na.rm = TRUE))


melbourne_housing %>%
  filter(suburb == "Toorak" | suburb == "Brighton") %>%
  filter(price > 2000000) %>%
  group_by(suburb) %>%
  summarise(number_of_houses = n())


##### Let do somne window functions
  #   dense_rank() :
  #   min_rank() : 
  #   row_number() : 
  #   cumsum() : 
  #   cummean() : 
  #   lead() : 
  #   lag() : 

melbourne_housing %>%
  filter(type == 'u') %>%
  filter(price > 1000000) %>%
  group_by(suburb) %>%
  summarise(number_of_units = n()) %>%
  mutate(suburb_rank = dense_rank(desc(number_of_units))) %>% # rank by row counts
  arrange(suburb_rank) # sort by rank asc


## conversion from wide data format to narrow data format with Spread and Gather
narrow_data_frame <- data.frame(name = c('Alice', 'Bob'),
                                subject = c('Maths', 'Science', 'English'),
                                marks = c(90, 90, 85, 75, 75, 60)) %>%
                      arrange(name, subject)

wide_data_frame <- narrow_data_frame %>% spread(subject, marks)

gather_data_frame <- wide_data_frame %>% gather(Subject, Marks, English, Maths, Science)

narrow_data_frame
wide_data_frame
gather_data_frame






### Join

melbourne_housing %>% 
  inner_join(suburb_data, by = 'suburb') %>%
  
  
  # join based on particular columns
  
melbourne_housing %>%
  inner_join(suburb_data, by = c('col_left_1', 'col_right_1'), c('col_left_2', 'col_right_2'))



##### Practices

### charge 2% of sold price as comission, give list a all agents and 
#how much commission made in 2017

melbourne_housing %>%
  mutate(dt = dmy(dt)) %>% # dmy : convert string to date
  mutate(yr = year(dt)) %>%
  mutate(price = as.numeric(price)) %>%
  filter(yr == 2017) %>%
  group_by(selling_agent) %>%
  summarise(total_commission = 0.02 * sum(price, na.rm = TRUE)) # na.rm : remove null values
  arrange(desc(total_commission))
  

### Top 5 most expensive suburbs descening order (median house), 
  # less than 10km from City

suburb_data %>%
  left_join(melbourne_housing, by = c('suburb', 'suburb')) %>%
  filter(distance_from_city < 10) %>%
  group_by(suburb) %>%
  summarise(suburb_med_price = median(price, na.rm = TRUE)) %>%
  mutate(top_exp_suburb = dense_rank(desc(suburb_med_price))) %>%
  arrange(top_exp_suburb) %>%
  head(5)


### suburbs in 10 to 20 from city, in the eastern metro region
  # compare of what the median prices of properties based on 2, 3, 4 bedrooms

melbourne_housing %>%
  left_join(suburb_data, by = 'suburb') %>%
  filter(between(distance_from_city, 10, 20)) %>%
  filter(str_detect(region_name, 'Eastern Metro')) %>%
  filter(rooms %in% c(2, 3, 4)) %>%
  group_by(suburb, rooms) %>%
  summarise(median_price = median(price, na.rm = TRUE)) %>%
  spread(rooms, median_price)
  
  





