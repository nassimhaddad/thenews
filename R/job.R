library(rvest)
library(stringr)

html_beginning <- "<!DOCTYPE html>\n    <html>\n    <head>\n        <meta charset=\"UTF-8\">\n        <title>The News</title>\n        <style>\n/* From extension jebbs.markdown-extended */\n@font-face {\n  font-family: \"Material Icons\";\n  font-style: normal;\n  font-weight: 400;\n  src: local(\"Material Icons\"), local(\"MaterialIcons-Regular\"), url(\"data:application/x-font-woff;charset=utf-8;base64,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\") format(\"woff\");\n}\n\n.admonition {\n  box-shadow: 0 2px 2px 0 rgba(0, 0, 0, .14), 0 1px 5px 0 rgba(0, 0, 0, .12), 0 3px 1px -2px rgba(0, 0, 0, .2);\n  position: relative;\n  margin: 1.5625em 0;\n  padding: 0 1.2rem;\n  border-left: .4rem solid rgba(68, 138, 255, .8);\n  border-radius: .2rem;\n  background-color: rgba(255, 255, 255, 0.05);\n  overflow: auto;\n}\n\n.admonition>p {\n  margin-top: .8rem;\n}\n\n.admonition>.admonition-title {\n  margin: 0 -1.2rem;\n  padding: .8rem 1.2rem .8rem 3.6rem;\n  border-bottom: 1px solid rgba(68, 138, 255, .2);\n  background-color: rgba(68, 138, 255, .1);\n  font-weight: 700;\n}\n\n.admonition>.admonition-title:before {\n  position: absolute;\n  left: 1.2rem;\n  font-size: 1.5rem;\n  color: rgba(68, 138, 255, .8);\n  content: \"\\E3C9\";\n}\n\n.admonition>.admonition-title:before {\n  font-family: Material Icons;\n  font-style: normal;\n  font-variant: normal;\n  font-weight: 400;\n  line-height: 2rem;\n  text-transform: none;\n  white-space: nowrap;\n  speak: none;\n  word-wrap: normal;\n  direction: ltr;\n}\n\n.admonition.summary,\n.admonition.abstract,\n.admonition.tldr {\n  border-left-color: rgba(0, 176, 255, .8);\n}\n\n.admonition.summary>.admonition-title,\n.admonition.abstract>.admonition-title,\n.admonition.tldr>.admonition-title {\n  background-color: rgba(0, 176, 255, .1);\n  border-bottom-color: rgba(0, 176, 255, .2);\n}\n\n.admonition.summary>.admonition-title:before,\n.admonition.abstract>.admonition-title:before,\n.admonition.tldr>.admonition-title:before {\n  color: rgba(0, 176, 255, 1);\n  ;\n  content: \"\\E8D2\";\n}\n\n.admonition.hint,\n.admonition.tip {\n  border-left-color: rgba(0, 191, 165, .8);\n}\n\n.admonition.hint>.admonition-title,\n.admonition.tip>.admonition-title {\n  background-color: rgba(0, 191, 165, .1);\n  border-bottom-color: rgba(0, 191, 165, .2);\n}\n\n.admonition.hint>.admonition-title:before,\n.admonition.tip>.admonition-title:before {\n  color: rgba(0, 191, 165, 1);\n  content: \"\\E80E\";\n}\n\n.admonition.info,\n.admonition.todo {\n  border-left-color: rgba(0, 184, 212, .8);\n}\n\n.admonition.info>.admonition-title,\n.admonition.todo>.admonition-title {\n  background-color: rgba(0, 184, 212, .1);\n  border-bottom-color: rgba(0, 184, 212, .2);\n}\n\n.admonition.info>.admonition-title:before,\n.admonition.todo>.admonition-title:before {\n  color: rgba(0, 184, 212, 1);\n  ;\n  content: \"\\E88E\";\n}\n\n.admonition.success,\n.admonition.check,\n.admonition.done {\n  border-left-color: rgba(0, 200, 83, .8);\n}\n\n.admonition.success>.admonition-title,\n.admonition.check>.admonition-title,\n.admonition.done>.admonition-title {\n  background-color: rgba(0, 200, 83, .1);\n  border-bottom-color: rgba(0, 200, 83, .2);\n}\n\n.admonition.success>.admonition-title:before,\n.admonition.check>.admonition-title:before,\n.admonition.done>.admonition-title:before {\n  color: rgba(0, 200, 83, 1);\n  ;\n  content: \"\\E876\";\n}\n\n.admonition.question,\n.admonition.help,\n.admonition.faq {\n  border-left-color: rgba(100, 221, 23, .8);\n}\n\n.admonition.question>.admonition-title,\n.admonition.help>.admonition-title,\n.admonition.faq>.admonition-title {\n  background-color: rgba(100, 221, 23, .1);\n  border-bottom-color: rgba(100, 221, 23, .2);\n}\n\n.admonition.question>.admonition-title:before,\n.admonition.help>.admonition-title:before,\n.admonition.faq>.admonition-title:before {\n  color: rgba(100, 221, 23, 1);\n  ;\n  content: \"\\E887\";\n}\n\n.admonition.warning,\n.admonition.attention,\n.admonition.caution {\n  border-left-color: rgba(255, 145, 0, .8);\n}\n\n.admonition.warning>.admonition-title,\n.admonition.attention>.admonition-title,\n.admonition.caution>.admonition-title {\n  background-color: rgba(255, 145, 0, .1);\n  border-bottom-color: rgba(255, 145, 0, .2);\n}\n\n.admonition.attention>.admonition-title:before {\n  color: rgba(255, 145, 0, 1);\n  content: \"\\E417\";\n}\n\n.admonition.warning>.admonition-title:before,\n.admonition.caution>.admonition-title:before {\n  color: rgba(255, 145, 0, 1);\n  content: \"\\E002\";\n}\n\n.admonition.failure,\n.admonition.fail,\n.admonition.missing {\n  border-left-color: rgba(255, 82, 82, .8);\n}\n\n.admonition.failure>.admonition-title,\n.admonition.fail>.admonition-title,\n.admonition.missing>.admonition-title {\n  background-color: rgba(255, 82, 82, .1);\n  border-bottom-color: rgba(255, 82, 82, .2);\n}\n\n.admonition.failure>.admonition-title:before,\n.admonition.fail>.admonition-title:before,\n.admonition.missing>.admonition-title:before {\n  color: rgba(255, 82, 82, 1);\n  ;\n  content: \"\\E14C\";\n}\n\n.admonition.danger,\n.admonition.error,\n.admonition.bug {\n  border-left-color: rgba(255, 23, 68, .8);\n}\n\n.admonition.danger>.admonition-title,\n.admonition.error>.admonition-title,\n.admonition.bug>.admonition-title {\n  background-color: rgba(255, 23, 68, .1);\n  border-bottom-color: rgba(255, 23, 68, .2);\n}\n\n.admonition.danger>.admonition-title:before {\n  color: rgba(255, 23, 68, 1);\n  content: \"\\E3E7\";\n}\n\n.admonition.error>.admonition-title:before {\n  color: rgba(255, 23, 68, 1);\n  content: \"\\E14C\";\n}\n\n.admonition.bug>.admonition-title:before {\n  color: rgba(255, 23, 68, 1);\n  content: \"\\E868\";\n}\n\n.admonition.example,\n.admonition.snippet {\n  border-left-color: rgba(0, 184, 212, .8);\n}\n\n.admonition.example>.admonition-title,\n.admonition.snippet>.admonition-title {\n  background-color: rgba(0, 184, 212, .1);\n  border-bottom-color: rgba(0, 184, 212, .2);\n}\n\n.admonition.example>.admonition-title:before,\n.admonition.snippet>.admonition-title:before {\n  color: rgba(0, 184, 212, 1);\n  ;\n  content: \"\\E242\";\n}\n\n.admonition.quote,\n.admonition.cite {\n  border-left-color: rgba(158, 158, 158, .8);\n}\n\n.admonition.quote>.admonition-title,\n.admonition.cite>.admonition-title {\n  background-color: rgba(158, 158, 158, .1);\n  border-bottom-color: rgba(158, 158, 158, .2);\n}\n\n.admonition.quote>.admonition-title:before,\n.admonition.cite>.admonition-title:before {\n  color: rgba(158, 158, 158, 1);\n  ;\n  content: \"\\E244\";\n}\n.vscode-light kbd,\n.vscode-dark kbd,\n.vscode-high-contrast kbd {\n  display: inline-block;\n  padding: 3px 5px;\n  font: 11px \"SFMono-Regular\", Consolas, \"Liberation Mono\", Menlo, Courier, monospace;\n  line-height: 10px;\n  vertical-align: middle;\n  border: solid 1px #d1d5da;\n  border-bottom-color: #c6cbd1;\n  border-radius: 3px;\n  box-shadow: inset 0 -1px 0 #c6cbd1;\n}\n\n.vscode-light kbd {\n  color: #444d56;\n  background-color: #fafbfc;\n}\n</style>\n        \n        <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/gh/Microsoft/vscode/extensions/markdown-language-features/media/markdown.css\">\n<link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/gh/Microsoft/vscode/extensions/markdown-language-features/media/highlight.css\">\n<style>\n            body {\n                font-family: -apple-system, BlinkMacSystemFont, 'Segoe WPC', 'Segoe UI', system-ui, 'Ubuntu', 'Droid Sans', sans-serif;\n                font-size: 14px;\n                line-height: 1.6;\n            }\n        </style>\n        <style>\n.task-list-item { list-style-type: none; } .task-list-item-checkbox { margin-left: -20px; vertical-align: middle; }\n</style>\n        \n        \n        \n</head>\n<body class=\"vscode-body vscode-light\">\n\n"



html_end <- "</body>\n</html>\n"



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



