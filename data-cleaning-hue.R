############################################################
#                                                          #
#                        Clean data                        #
#                           Hue                            #
#                                                          #
############################################################
# Load packages
library(tidyverse)
library(readxl)
library(janitor)

# Import data
data <- read_xlsx('data-original/hue-analysis.xlsx') %>%
    clean_names()

# Check data
dim(data)
head(data)
tail(data)
glimpse(data)

# Rename ID column
data <- data %>%
    rename(ID = individual)

# Convert to long format
data <- data %>%
    pivot_longer(cols = -c(ID, test_given),
                 names_to = 'colour',
                 values_to = 'SaO2')

# Add saturation column to match colour column
data <- data %>%
    mutate(colour_SaO2 = case_when(
        colour == 'colour_1' ~ 15,
        colour == 'colour_2' ~ 25,
        colour == 'colour_3' ~ 35,
        colour == 'colour_4' ~ 45,
        colour == 'colour_5' ~ 55,
        colour == 'colour_6' ~ 65,
        colour == 'colour_7' ~ 75,
        colour == 'colour_8' ~ 85,
        colour == 'colour_9' ~ 95
    ))

# Add error column
data <- data %>%
    mutate(delta = SaO2 - colour_SaO2) %>%
    mutate(error = ifelse(delta != 0,
                          yes = 1,
                          no = 0))

# Save cleaned data
if(dir.exists('data-cleaned')) {
    write_csv(data, 'data-cleaned/clean-data-hue.csv')
    write_rds(data, 'data-cleaned/clean-data-hue.rds')
} else {
    dir.create('data-cleaned')
    write_csv(data, 'data-cleaned/clean-data-hue.csv')
    write_rds(data, 'data-cleaned/clean-data-hue.rds')
}

# Session summary
sessionInfo()
