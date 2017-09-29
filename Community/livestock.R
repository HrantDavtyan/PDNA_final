tabPanel("Livestock",div(id="reset_inputs_livestock",
         selectizeInput("livestock", "Select type",choices = livestock_list,
                        options = list(create = TRUE,placeholder = "Which type of livestock was affected?")),
         conditionalPanel(condition ="input.livestock!=''",
                          fluidRow(column(4,numericInput("lost_livestock", "Units lost", min = 0, value = 0)),
                                   column(4,br(),actionButton("create_custom_livestock_income","Custom Income",width="58%",height = "00%",
                                                         style = "background-color: orange; border-color: orange;
                                                         color: white")),
                                   column(4,br(),actionButton("create_custom_livestock_repl","Custom Replacement Cost",width="58%",height = "100%",
                                                         style = "background-color: orange; border-color: orange;
                                                         color: white"))),
                          fluidRow(column(4,numericInput("injured_livestock","Units Injured",min = 0, value = 0)),
                                   conditionalPanel(condition ="input.injured_livestock > 0",
                                                    column(4, sliderInput("injury_livestock","Share of Reduction in Yield",
                                                                          min = 0, step = 5, max = 100, value = 75)),
                                                    column(4,br(),actionButton("create_custom_livestock_rec","Custom Recovery Cost",width="58%",height = "100%",
                                                                          style = "background-color: orange; border-color: orange;
                                                                          color: white")))),
                          fluidRow(column(2,actionButton("default_livestock","Use Defaults",
                                                         style = "background-color: #337ab7; border-color: #2e6da4;
                                                         color: white")),
                                   column(2,actionButton("create_custom_livestock","Create Custom",
                                                         style = "background-color: orange; border-color: orange;
                                                         color: white"))))))
