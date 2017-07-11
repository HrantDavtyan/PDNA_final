tabPanel("Annual crops",div(id="reset_inputs_annual",
         selectizeInput("crop", "Crop name",choices = crop_list,
                        options = list(create = TRUE,placeholder = "Which crop was affected?")),
         conditionalPanel(condition ="input.crop!=''",
                          selectInput("unit","Measurement Unit", choices = list("Ha","M2")),
                          fluidRow(column(6,numericInput("lost", "Units lost", min = 0, value = 0)),
                                   conditionalPanel(condition="input.lost>0",
                                                    column(6, radioButtons("replanting","Replanting possible",
                                                                           choices = c("Yes","No"), inline=TRUE)))),
                          fluidRow(column(6,numericInput("reduced","Units with Reduced Yield",min = 0, value = 0)),
                                   conditionalPanel(condition ="input.reduced >0",
                                                    column(6, sliderInput("reduction","Share of Reduction",
                                                                          min = 0, step = 5, max = 100, value = 75)))),
                          fluidRow(column(2,actionButton("default","Use Defaults",
                                                         style = "background-color: #337ab7; border-color: #2e6da4;
                                                         color: white")),
                                   column(2,actionButton("create_custom_crop","Create Custom",
                                                         style = "background-color: orange; border-color: orange;
                                                         color: white")))
                          )))
