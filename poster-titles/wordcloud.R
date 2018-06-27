d <- httr::GET("http://ismir2018.ircam.fr/pages/events-main-program.html")

text <- d %>% 
  xml2::read_html() %>% 
  xml2::xml_find_all("//div//p") %>% 
  rvest::html_text() %>% 
  stringr::str_replace_all(pattern = "\n(.*)",
                           replacement = "") %>% 
  as.data.frame() %>% 
  purrr::set_names("text") %>% 
  dplyr::mutate(text = as.character(text))


text_tidy <- text %>%
  tidytext::unnest_tokens(word, text) %>% 
  dplyr::filter(!(word) %in% c(tidytext::stop_words$word)) %>% 
  dplyr::count(word, sort = TRUE)

library(wordcloud)
text_tidy %>% with(wordcloud(word, n, 
                             family = "serif", 
                             min.freq = 3,
                             max.words = 50,
                             colors = brewer.pal(n = 5, "Accent")))