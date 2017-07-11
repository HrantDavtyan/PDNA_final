box(title = "Annual crops", solidHeader = TRUE, width = NULL,
    status = "primary",
    fluidRow(column(6,
                    selectizeInput("crop", "Crop name",choices = crop_list,
                                   options = list(create = TRUE,placeholder = "Which crop was affected?"))),
             column(6,
                    selectInput("unit","Measurement Unit", choices = list("Ha","M2"))
             )),
    fluidRow(column(6,
                    numericInput("styield","Standard yearly income yield / unit", min = 0, value = 0)),
             column(6,
                    numericInput("repyield", "Replanted income yield / unit",min = 0, value = 0))),
    fluidRow(column(6,
                    numericInput("repcost","Replanting cost / unit",min = 0, value = 0)),
             column(6,
                    numericInput("reccost","Recovery cost / unit",min = 0, value = 0)))
            )