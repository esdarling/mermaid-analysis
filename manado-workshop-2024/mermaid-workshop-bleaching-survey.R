#code to pull list of projects and data sharing choices 

# install.packages("remotes")
# remotes::install_github("data-mermaid/mermaidr")

library(mermaidr)
library(tidyverse)
library(janitor)
library(here)


projects <- mermaid_get_my_projects()
projects

projects %>% 
  filter(str_detect(name, "Siquijor")) %>% 
  mermaid_get_project_data(method = "fishbelt", data = "sampleevents")

data <- .Last.value

names(data)

site_summary <- data %>% 
  select(site, 
         management, 
         #observers, 
         depth_avg, 
         #count_total_avg, 
         count_genera_avg, 
         percent_normal_avg, 
         percent_bleached_avg, 
         percent_hard_avg_avg)

#use genera dominance (e.g., relative perc colonies Acropora)
?mermaid_get_project_data

projects %>% 
  filter(str_detect(name, "Manado")) %>% 
  mermaid_get_project_data(method = "bleaching", data = "observations")

corals <- .Last.value
names(corals$colonies_bleached)

acropora <- corals$colonies_bleached %>% 
  select(site, 
         management, 
         observers,
         benthic_attribute, 
         count_normal) %>% 
  filter(benthic_attribute == "Acropora") %>% 
  group_by(site, 
           management, 
           observers,
           benthic_attribute) %>% 
  summarize(sum_acropora = sum(count_normal)) %>% 
  group_by(site, 
           management, 
           benthic_attribute) %>% 
  summarize(sum_acropora = sum(sum_acropora))

total_cols <- corals$colonies_bleached %>% 
  select(site, 
         management, 
         observers,
         count_normal) %>% 
  group_by(site, 
           management, 
           observers) %>% 
  summarize(sum_cols = sum(count_normal)) %>% 
  group_by(site, 
           management) %>% 
  summarize(sum_cols = sum(sum_cols))

total_cols
acropora

acropora <- total_cols %>% 
  left_join(acropora) %>% 
  mutate(perc_acropora = sum_acropora / sum_cols * 100) %>% 
  filter(!is.na(sum_acropora))

acropora
hist(acropora$perc_acropora)
glimpse(acropora$perc_acropora)

acropora

#add Acropora to total data
join <- site_summary %>% 
  left_join(acropora) %>% 
  select(-sum_cols, 
         -benthic_attribute, 
         -sum_acropora)

join

write_csv(join, here("manado-bleach-summary.csv"))

  
