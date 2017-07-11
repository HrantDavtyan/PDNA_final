body <- dashboardBody(tabItems(
  tabItem(tabName = "dashboard",
          fluidRow(infoBoxOutput("total_damage_box"),
          column(1,""),
          column(width=2,dropdownButton(width="200%",icon=icon("filter"),tooltip = tooltipOptions(title = "Filter data on map"),
					selectizeInput("filter_disaster",label="Disaster type",
            choices=c("All","Annual crops","Trees and Bushes","Livestock","Assets and Equipment","Lands and Infrastructure"),multiple=FALSE,selected=NULL))),
					infoBoxOutput("total_loss_box")
          ),
          fluidRow(
            column(width = 12,
                       leafletOutput("mymap"))#)
                   )
  ),
  tabItem(tabName = "review",
          fluidRow(
            column(2,
              selectizeInput("select_effect",label=NULL,
                            options=list(placeholder="Select effect"),
                            choices=c("","an_cr_entry","tree_entry","land_entry",
                                      "asset_entry","livestock_entry"))),
        column(1,
		            dropdownButton(tags$style("width: 100px; margin-left: 0px; margin-right: 30px;"),
                  icon=icon("download"),circle=FALSE,
                  tooltip = tooltipOptions(placement="top",
                    title = "Click to download datasets"),
					tags$h4("Download dataset for:"),
					actionLink("download_crop","Annual Crops"),
					actionLink("download_tree","Trees and Bushes"),
					actionLink("download_livestock","Livestock"),
					actionLink("download_asset","Assets and Equipment"),
					actionLink("download_land","Lands and Infrastructure")
					)),
        column(width=1,offset=7,
          actionButton("edit_data","Edit Data",icon("edit")))
				),
          br(),
          fluidRow(
            column(12,
                   conditionalPanel(condition="input.select_effect!=''",
                   dataTableOutput("table"))),
            bsModal("edit_table_modal","Edit data","edit_data",size = "large",footer=NULL,
                    htable("edit_table",colHeaders="provided"),
                    actionButton("submit_edit_table","Submit modifications")),
            bsModal("confirmation","Success!", "submit_edit_table",size="small",
                    helpText("Your changes have been saved to database"))
          )
  ),
  tabItem(tabName = "defaults",
          wellPanel(style = "background-color: #ffffff;",fluidRow(column(6,
              selectizeInput("default_marz",label="Marz",choices=marz_list,selected=NULL)),
              column(6,
              selectizeInput("default_affect", label ="Disaster effects", selected = NULL,
                                choices = c("","Annual crops","Livestock","Trees and Bushes")))
              )),
          fluidRow(column(12,uiOutput("ui_inputs"))),
          fluidRow(column(4,offset = 4,
                          actionButton("update_defaults","Update",width = "100%"))),
          bsModal("def_update_confirmation","Success !","update_defaults",size="small",
            helpText("Default values have been updated")
          )
  ),
  tabItem(tabName = "test",
          tags$iframe(id = "googleform",
                      src = 'https://docs.google.com/spreadsheets/d/1YxO4SEor1cDYcA2nBl-zFzNEkfD3TiWOYJ3a8rpxQ6E/pubhtml?gid=0&amp;single=true&amp;widget=true&amp;headers=false',
                      width = "100%",
                      height = 1000,
                      frameborder = 0,
                      marginheight = 0)
  ),
  tabItem(tabName = "help",
          fluidRow(leafletOutput("contacts_map")#,
                   )
  )
)
)
