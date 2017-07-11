box(title = "Livestock", solidHeader = TRUE, width = NULL,
    status = "primary",
    fluidRow(column(6,
                    selectizeInput("Type", "Type",choices = livestock_list,
                                   options = list(create = TRUE,placeholder = "Which type was affected?"))),
             column(6,
                    numericInput("age_livestock","Age",min = 0, value = 0)
             )),
    fluidRow(column(12,numericInput("styield_livestock","Standard yearly income yield / unit", min = 0, value = 0))),
    fluidRow(column(6,
                    numericInput("replcost_livestock","Replacement cost / unit",min = 0, value = 0)),
             column(6,
                    numericInput("reccost_livestock","Recovery cost / unit",min = 0, value = 0)))
            )