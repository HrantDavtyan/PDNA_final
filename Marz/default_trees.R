box(title = "Trees and Bushes", solidHeader = TRUE, width = NULL,
    status = "primary",
    fluidRow(column(6,
                    selectizeInput("Type", "Type",choices = tree_bush_list,
                                   options = list(create = TRUE,placeholder = "Which type was affected?"))),
             column(6,
                    selectInput("unit","Measurement Unit", choices = list("Ha","M2"))
             )),
    fluidRow(column(12,numericInput("styield","Standard yearly income yield / unit", min = 0, value = 0))),
    fluidRow(column(6,
                    numericInput("repcost_tree","Replanting cost / unit",min = 0, value = 0)),
             column(6,
                    numericInput("reccost_tree","Recovery cost / unit",min = 0, value = 0)))
            )