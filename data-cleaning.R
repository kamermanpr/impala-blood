############################################################
#                                                          #
#                        Clean data                        #
#                                                          #
############################################################
# Load packages
library(tidyverse)
library(magrittr)
library(readxl)
library(skimr)

# Set skimr variables
skim <- skim_with(numeric = sfl(hist = NULL),
                  factor = sfl(ordered = NULL))

# Import data
data <- read_xlsx('data-original/21-11-2018.xlsx')

# Check data
dim(data)
head(data)
tail(data)
glimpse(data)

# Force Hct from character to numeric
data$Hct <- as.numeric(data$Hct)

# Check summary stats
data[, -1] %>%
    mutate_if(is.character, factor) %>%
    skim()

# Double-check Hct (at least on reading = 1)
data$Hct

# Remove value of 1 from Hct
data$Hct[data$Hct == 1] <- NA

# Was supplemental oxygen given?
data %<>%
    mutate(O2_suppl = ifelse(PaO2 >= 100 | Time_min > 30,
                             yes = 'Yes',
                             no = 'No'))

# Final check of summary stats
data[, -1] %>%
    mutate_if(is.character, factor) %>%
    skim()

# Save cleaned data
if(dir.exists('data-cleaned')) {
    write_csv(data, 'data-cleaned/clean-data.csv')
    write_rds(data, 'data-cleaned/clean-data.rds')
} else {
    dir.create('data-cleaned')
    write_csv(data, 'data-cleaned/clean-data.csv')
    write_rds(data, 'data-cleaned/clean-data.rds')
}

# Session summary
sessionInfo()
