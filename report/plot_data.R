## 01_clean_data.R

## this script cleans up the raw survey data for summarizing and plotting

#### inits ####

library(here)
library(dplyr)

#### read data ####

data_raw <- readr::read_csv(here("data", "raw", "cru_peer_mentoring_survey.csv"))

#### admin ####

data_admin <- data_raw %>%
  select(starts_with("Administration")) %>%
  select(!contains("format")) %>%
  select(!contains("other topics"))
  
## number of mentees
mentees <- (data_admin == "Mentee" | data_admin == "Mentor;Mentee") %>%
  apply(2, sum, na.rm = TRUE)

## number of mentors
mentors <- (data_admin == "Mentor" | data_admin == "Mentor;Mentee") %>%
  apply(2, sum, na.rm = TRUE)

data_plot <- rbind(mentees, mentors)

topics <- data_admin %>%
  colnames() %>%
  sub(pattern = "(^.*\\[)(.*)(\\])", replacement = "\\2")

barplot(data_plot, beside = TRUE,
        names.arg = topics,
        horiz = TRUE)

