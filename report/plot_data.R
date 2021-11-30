## 01_clean_data.R

## this script cleans up the raw survey data for summarizing and plotting

#### inits ####

library(here)
library(dplyr)

#### read data ####

data_raw <- readr::read_csv(here("data", "raw", "cru_peer_mentoring_survey.csv"))

#### admin ####

## admin responses
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

## matrix of data for plotting
data_plot <- rbind(mentees, mentors)

## list of topics
topics <- data_admin %>%
  colnames() %>%
  sub(pattern = "(^.*\\[)(.*)(\\])", replacement = "\\2")

## plot summary info
par(mai = c(0.9, 2.9, 0.6, 0.1),
    omi = rep(0.1, 4))
barplot(data_plot, beside = TRUE,
        col = c("dodgerblue", "indianred"), border = NA,
        names.arg = topics,
        legend.text = TRUE,
        args.legend = list(x = "top", inset = -0.2, bty = "n", border = NA,
                           xpd = TRUE, cex = 0.8),
        horiz = TRUE, las = 1, cex.names = 0.8,
        xlab = "Number of responses")

