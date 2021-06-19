library(rvest)
library(stringr)

fileName <- 'html_beginning.txt'
html_beginning <- readChar(fileName, file.info(fileName)$size)

fileName <- 'html_end.txt'
html_end <- readChar(fileName, file.info(fileName)$size)


# getting the raw data
theyear <- read_html("https://en.wikipedia.org/wiki/2021")
# theyear %>% html_elements("span.mw-headline")
ul_all_months <- theyear %>% html_elements("h3 + ul")
# ul_all_months
all_items <- ul_all_months %>% html_elements("li") %>% as.character()
sub_items <- ul_all_months %>% html_elements("ul li") %>% as.character()

main_items <- all_items[!all_items %in% sub_items]
main_items <- rev(main_items)



# removing items not corresponding to a month
months_names <- rev(c("January", "February", "March", "April", "May", "June"))
months_beginning <- paste0('^<li>\n<a href=\"/wiki/', months_names)
beginning_checker <- paste(months_beginning, collapse = "|")
main_items <- main_items[str_detect(main_items, beginning_checker)]

month_titles <- str_replace_all('<h3>MONTH</h3>', "MONTH", months_names)

page_title <- '<a for="toc-anchor" id="the-news"></a><h1 id="the-news">The News</h1>'

# removing noise in the text
main_items <- str_remove_all(main_items, "<sup.*/sup>")



# add beginning and end
doc_content <- c(html_beginning, page_title)

for (i in seq(months_names)){
  doc_content <- c(doc_content, 
                   month_titles[i], 
                   "<ul>",
                   main_items[str_detect(main_items, months_beginning[i])],
                   "</ul>")
}

# absolute wikipedia links
doc_content <- str_replace_all(doc_content, 
                               '"/wiki/', '"https://en.wikipedia.org/wiki/')

# add end notes
end_notes <- paste0("<hr><h4>About</h4>\nContent source: https://en.wikipedia.org/wiki/2021. Last updated: ", Sys.time())
doc_content <- c(doc_content, 
                 end_notes)

doc_content <- c(doc_content, html_end)


writeLines(doc_content, "output/thenews/index.html")



