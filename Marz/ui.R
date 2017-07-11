library(shiny)
library(shinydashboard)
library(shinyBS)
library(shinyWidgets)

source('header.R',local=TRUE)
source('sidebar.R',local=TRUE)
source('body.R',local=TRUE)

dashboardPage(header, sidebar, body)
