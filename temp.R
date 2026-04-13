pacman::p_load(
  tidyverse, sf, units, tigris, rnaturalearth, gghighlight, ggrepel, flextable
)

states <- states(cb = TRUE, progress_bar = FALSE) %>% 
  filter(!STUSPS %in% c("AK", "HI", "PR", "MP", "VI", "AS", "GU", "DC")) %>%
  st_transform(5070)

cities <- read_csv("data/simplemaps_uscities/uscities.csv") %>% 
  st_as_sf(coords = c("lng", "lat"), crs = 4326) %>% 
  st_transform(5070) %>%
  filter(!state_name %in% c("Alaska", "Hawaii", "Puerto Rico", "District of Columbia"))

states_union <- st_union(states) %>% 
  st_cast("MULTILINESTRING")

cities$dist_to_border <- st_distance(cities, states_union) %>% 
  set_units("km") %>% 
  units::drop_units()

tmp = as.vector(cities$dist_to_border)

slice_max(cities, dist_to_border, n = 5)
