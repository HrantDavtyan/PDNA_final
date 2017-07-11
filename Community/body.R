body <- dashboardBody(useShinyjs(), extendShinyjs(text = jscode),tabItems(
  tabItem(tabName = "dashboard",
          fluidRow(
            box(id="disaster_event_box", title = uiOutput("box_title"), solidHeader = TRUE, width = 6,
                status = "primary", collapsible = TRUE, collapsed=TRUE,
              dateRangeInput("date", "Date input", start = NULL, end=NULL),
              selectizeInput("marz",label="Marz",choices=marz_list,selected=NULL),
              selectizeInput("disaster", label = "Disaster",choices = disaster_list, selected = 1),
              textAreaInput("description",label = "Description",height = '150px'),
              column(2, offset = 10, actionButton("submit_event", label = "Next", width = '120%'))
              
            ),
            conditionalPanel(condition = "input.submit_event%2==1",
            box(id="new_entry_box",collapsible = TRUE,
                title = "Make a new entry", width = 6, solidHeader = TRUE, status = "warning",
                textInput("name", label = "Name",placeholder = "Please enter farmer's full name"),
                selectizeInput("community",label="Community",choices=community_list,selected=NULL),
                column(2, offset = 10, actionButton("submit_entry", label = "Next", width = '120%'))
            )
            )
          ),
          conditionalPanel(condition="(input.submit_entry + input.finish_entry) %2==1",
                           fluidRow(
                             tabBox( id = "type_tab",
                               width = 12, title = "Input data",
                               source("annual.R",local=TRUE)$value,
                               source("tree.R",local=TRUE)$value,
                               source("livestock.R",local=TRUE)$value,
                               source("land.R",local=TRUE)$value,
                               source("assets.R",local=TRUE)$value
                             )),
                           fluidRow(column(2,offset=5,actionButton("finish_entry","Finish Entry", width="100%")))
                           ),
                           conditionalPanel(condition='input.default+input.custom_crop!=0',
                            dataTableOutput("annual_inputs_table")
                            ),
                           conditionalPanel(condition='input.default_tree+input.custom_tree!=0',
                            dataTableOutput("tree_inputs_table")
                            ),
                           conditionalPanel(condition='input.default_livestock+input.custom_livestock!=0',
                            dataTableOutput("livestock_inputs_table")
                            ),
                           conditionalPanel(condition='input.default_asset!=0',
                            dataTableOutput("asset_inputs_table")
                            ),
                           conditionalPanel(condition='input.default_land!=0',
                            dataTableOutput("lands_inputs_table")
                            )

  ),
  tabItem(tabName = "report",
          dataTableOutput("table")
  )
),
# Confirmation windows, reacting to "Use Defaults" click in all 5 categories
bsModal("confirmation_crop", "Confirmation", "default", size = "small",
        helpText("Your submission is saved to database")),
bsModal("confirmation_tree", "Confirmation", "default_tree", size = "small",
        helpText("Your submission is saved to database")),
bsModal("confirmation_land", "Confirmation", "default_land", size = "small",
        helpText("Your submission is saved to database")),
bsModal("confirmation_asset", "Confirmation", "default_asset", size = "small",
        helpText("Your submission is saved to database")),
bsModal("confirmation_livestock", "Confirmation", "default_livestock", size = "small",
        helpText("Your submission is saved to database")),

# Confirmation windows, reacting to "Submit custom" click in 3 categories that have the button
bsModal("confirmation", "Confirmation", "custom_crop", size = "small",
        helpText("Your submission is saved to database")),
bsModal("confirmation", "Confirmation", "custom_tree", size = "small",
        helpText("Your submission is saved to database")),
bsModal("confirmation", "Confirmation", "custom_livestock", size = "small",
        helpText("Your submission is saved to database")),

# the Model window, reacting to "Create Custom" click in 3 categories that have the button
bsModal(id="custom_inputs_crop","Custom Inputs","create_custom_crop", wellPanel(
    numericInput("styield","Standard yearly income yield / unit", min = 0, value = 0),
    numericInput("repyield", "Replanted income yield / unit",min = 0, value = 0),
    numericInput("repcost","Replanting cost / unit",min = 0, value = 0),
    numericInput("reccost","Recovery cost / unit",min = 0, value = 0),
    textInput("reason_crop","Reason for custom", placeholder = "Explain why you decided to create custom"),
    actionButton("custom_crop", "Submit with customs"))),
bsModal("custom_inputs_tree","Custom Inputs","create_custom_tree",wellPanel(
    numericInput("styield_tree","Standard yearly income yield / unit", min = 0, value = 0),
    numericInput("repcost_tree","Replanting cost / unit",min = 0, value = 0),
    numericInput("reccost_tree","Recovery cost / unit",min = 0, value = 0),
    textInput("reason_tree","Reason for custom", placeholder = "Explain why you decided to create custom"),
    actionButton("custom_tree", "Submit with customs"))),
bsModal("custom_inputs_livestock","Custom Inputs","create_custom_livestock",wellPanel(
    numericInput("styield_livestock","Standard yearly income", min = 0, value = 0),
    numericInput("replcost_livestock","Replacement cost / unit",min = 0, value = 0),
    numericInput("reccost_livestock","Recovery cost / unit",min = 0, value = 0),
    textInput("reason_livestock","Reason for custom", placeholder = "Explain why you decided to create custom"),
    actionButton("custom_livestock", "Submit with customs")))
)