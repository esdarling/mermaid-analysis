#code to pull list of projects and data sharing choices 

# install.packages("remotes")
# remotes::install_github("data-mermaid/mermaidr")

library(mermaidr)
library(tidyverse)
library(janitor)
library(here)


mermaid_get_projects()

projects <- .Last.value

names(projects)

projects %>% 
  filter(str_detect(countries, "Indonesia")) %>% 
  filter(str_detect(tags, "WCS")) %>% 
  arrange(name) %>% 
  select(-id) %>% 
  #tabyl(status)
  #view()
  write_csv(here("wcs-indonesia", "list-of-wcs-ip-projects-15mar2024.csv"))
  
