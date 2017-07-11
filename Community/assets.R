tabPanel("Assets and Equipment",div(id="reset_inputs_assets",
selectizeInput("asset", "Select type",choices = asset_list,
               options = list(create = TRUE,placeholder = "Which type of asset was affected?")),
conditionalPanel(condition ="input.asset!=''",
                 fluidRow(column(6,selectInput("unit_asset","Measurement Unit", choices = list("Piece","Kg","Ton"))),
                          column(6,numericInput("affected_asset","Units affected",min = 0, value = 0))),
                 fluidRow(column(6,numericInput("replcost_asset","Replacement cost",min = 0, value = 0)),
                          column(6,numericInput("reprcost_asset","Repair cost",min = 0, value = 0))),
                 fluidRow(column(2,actionButton("default_asset","Use Defaults",
                                                style = "background-color: #337ab7; border-color: #2e6da4;
                                                color: white"))))))
