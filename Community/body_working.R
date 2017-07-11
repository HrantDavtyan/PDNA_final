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
                           fluidRow(column(2,offset=5,actionButton("finish_entry","Finish Entry", width="100%"))),
                           conditionalPanel(condition=
          '(input.default + input.default_tree + input.default_land + input.default_asset + input.default_livestock + input.custom_crop + input.custom_tree + input.custom_livestock) !=0',
                           htable("view_results",colHeaders="provided"))
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
    numericInput("styield","Standard yearly income yield / unit / year (USD)", min = 0, value = 0),
    numericInput("repcost","Replanting cost for destroyed crops / unit (USD)",min = 0, value = 0),
    numericInput("repyield", "Replanted income yield / unit (USD)",min = 0, value = 0),
    numericInput("reccost","Recovery cost for damaged crops / unit / year (USD)",min = 0, value = 0),
    textInput("reason_crop","Please elaborate why customs values are applicable",
              placeholder = "Explain in comparison with default values"),
    fluidRow(column(6,fileInput("upload_crops","Upload your calculations")),
             column(6,actionButton("custom_crop", "Submit with customs"))))),
bsModal("custom_inputs_tree","Custom Inputs","create_custom_tree",wellPanel(
    numericInput("styield_tree","Standard yearly income yield / unit / year (USD)", min = 0, value = 0),
    numericInput("repcost_tree","Replanting cost for destroyed crops / unit (USD)",min = 0, value = 0),
    numericInput("reccost_tree","Recovery cost for damaged crops / unit / year (USD)",min = 0, value = 0),
    textInput("reason_tree","Please elaborate why customs values are applicable",
              placeholder = "Explain in comparison with default values"),
    fluidRow(column(6,fileInput("upload_trees","Upload your calculations")),
             column(6,actionButton("custom_tree", "Submit with customs"))))),
bsModal("custom_inputs_livestock","Custom Inputs","create_custom_livestock",wellPanel(
    numericInput("styield_livestock","Standard yearly income / year (USD)", min = 0, value = 0),
    numericInput("replcost_livestock","Replacement cost / unit (USD)",min = 0, value = 0),
    numericInput("reccost_livestock","Recovery cost / unit / year (USD)",min = 0, value = 0),
    textInput("reason_livestock","Please elaborate why customs values are applicable",
              placeholder = "Explain in comparison with default values"),
    fluidRow(column(6,fileInput("upload_livestock","Upload your calculations")),
             column(6,actionButton("custom_livestock", "Submit with customs")))))
)
