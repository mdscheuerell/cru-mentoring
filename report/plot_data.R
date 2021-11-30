## plot_data.R

## this script cleans up the raw survey data for summarizing and plotting

#### inits ####

library(here)
library(dplyr)

#### read data ####

data_raw <- readr::read_csv(here("data", "raw", "cru_peer_mentoring_survey.csv"))

#### admin ####

## admin data
data_admin <- data_raw %>%
  select(starts_with("Administration"))

## mentoring format
format_admin <- data_admin %>%
  select(contains("format"))

## mentoring format == depends
format_depends <- format_admin %>%
  table() %>%
  names() %>%
  grep(pattern = "Depends")

## mentoring format summary
format_admin_smry <- c(format_smry[-format_depends], sum(format_smry[format_depends]))
names(format_admin_smry)[3] <- "Depends on the topic"

## admin responses
responses_admin <- data_admin %>%
  select(!contains("format")) %>%
  select(!contains("other topics"))

## plot response summary info
par(mai = c(0.9, 2.9, 0.1, 0.1),
    omi = rep(0.1, 4))
barplot(rev(format_admin_smry),
        border = NA,
        horiz = TRUE, las = 1, cex.names = 0.8,
        xlab = "Number of responses")


## number of mentees
mentees <- (responses_admin == "Mentee" | responses_admin == "Mentor;Mentee") %>%
  apply(2, sum, na.rm = TRUE)

## number of mentors
mentors <- (responses_admin == "Mentor" | responses_admin == "Mentor;Mentee") %>%
  apply(2, sum, na.rm = TRUE)

## matrix of data for plotting
data_plot <- rbind(mentees, mentors)

## list of topics
topics <- responses_admin %>%
  colnames() %>%
  sub(pattern = "(^.*\\[)(.*)(\\])", replacement = "\\2")

## plot response summary info
par(mai = c(0.9, 2.9, 0.6, 0.1),
    omi = rep(0.1, 4))
barplot(data_plot, beside = TRUE,
        col = c("dodgerblue", "indianred"), border = NA,
        names.arg = topics,
        legend.text = TRUE,
        args.legend = list(x = "top", inset = -0.1, bty = "n", border = NA,
                           xpd = TRUE, cex = 0.8),
        horiz = TRUE, las = 1, cex.names = 0.8,
        xlab = "Number of responses")

