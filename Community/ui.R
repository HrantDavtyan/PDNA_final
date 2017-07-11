library(shinydashboard)
library(shinyBS)
library(shinyjs)

eval(parse('header.R', encoding="UTF-8"))
eval(parse('sidebar.R', encoding="UTF-8"))
eval(parse('body.R', encoding="UTF-8"))

dashboardPage(header, sidebar, body)
