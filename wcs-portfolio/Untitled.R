#code to pull list of projects and data sharing choices 

# install.packages("remotes")
# remotes::install_github("data-mermaid/mermaidr")

library(mermaidr)
library(tidyverse)
library(janitor)
library(here)


mermaid_get_projects() %>% 
  dplyr::filter(str_detect(tags, "WCS"))

wcs <- as_tibble(.Last.value)
wcs

?mermaid_get_project_data

wcs_biomass <- wcs %>% 
  filter(str_detect(data_policy_beltfish, "Public")) %>% 
  filter(id != "017270c0-4184-4b0e-bd1b-36b2ab8902e1") %>% 
  mermaid_get_project_data(method = "fishbelt", data = "sampleevents")
