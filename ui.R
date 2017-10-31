#install.packages("shinydashboard")
#install.packages("DT")
#install.packages("ggplot2")
#install.packages("RMongo")
#install.packages("dplyr")
#install.packages("sqldf")
#install.packages("plotly")
#install.packages("tidyr")
#install.packages("stringr")
#install.packages("stringi")

library(shiny)
library(shinydashboard)
library(plotly)
library(dplyr)
library(ggplot2)

#Set working directory
setwd("C:/Users/Tan/Desktop/Big data/Data processing/Individual assignment")

#Loading and manipulating data
source("Individuele_opdracht.R")

ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "RatingsOverTheYears", titleWidth = 300),
  dashboardSidebar(
    width = 300,
    sidebarMenu(
      id = "sidebar",
      menuItem(
        "Linechart",
        tabName = "linechart",
        icon = icon("line-chart")
      ),
      menuItem("Data Explorer", tabName = "dataexplorer", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "linechart",
        h2("Line chart"),
        box(
          collapsible = TRUE,
          width = 9,
          status = "primary",
          plotlyOutput('plot1')
        ),
        box(
          collapsible = TRUE,
          width = 3,
          status = "warning",
          selectInput("dataset1", "Select dataset", c("MovieLens" = "ml", "Mockaroo" = "md"), multiple = TRUE, selected = "ml")
        )
      ),
      tabItem(tabName = "dataexplorer",
              h2("Data Explorer"),
              fluidPage(
                tabBox(
                  width = 9,
                  title = "",
                  tabPanel("Data",
                           DT::dataTableOutput("datatable1"))
                )
              ))
    )
  )
)

