library("RMySQL")
library(shinyjs)

mydb <<- NULL

loadData <- function() {
  if (exists("responses")) {
    database

  }
}

function(input,output,session) {
  formData <- reactive({
    data <- sapply(fields, function(x) input[[x]])
    data
  })

  # collabse disaster_event_box once Next (submit_event) button is clicked
  observeEvent(input$submit_event, {
    js$collapse("disaster_event_box")
  })

  # collabse new_entry_box once Next (submit_entry) button is clicked
  observeEvent(input$submit_entry, {
    js$collapse("new_entry_box")
  })

  # change the title of disaster event box
  output$box_title <- renderText({
    if(input$disaster=="" || input$marz=="")
      "Create a Disaster Event"
    else if(input$disaster!="" & input$marz!="" & input$name=="")
      paste(input$disaster,input$marz,input$date[1],sep="  ")
    else
      paste(input$disaster,input$marz,input$date[1],":",input$name,sep="  ")
  })

  # function for making connection to DB
  connect_to_db<-function(){

    if(is.null(mydb)){
      all_cons <- dbListConnections(MySQL())
      for(con in all_cons)
        dbDisconnect(con)

      #mydb <<- dbConnect(MySQL(), user='pdnaahos_hrant',password='DiliJan7',dbname='pdnaahos_pdna', host='pdna.a2hosted.com')
      mydb <<- dbConnect(MySQL(), user='root',dbname='pdna', host='127.0.0.1')

    }
    return (mydb)
  }

  # function for refreshing output table (loading and showing data)
  refresh_table <- function(effecto){
    mydb = connect_to_db()
    print("a")
    rs = dbSendQuery(mydb, paste0("select * from ",effecto))
    rs = fetch(rs, n=-1)
    responses <<- rs
    responses["name"] <<- ""
    responses["community"] <<- ""
    responses["disaster"] <<- ""
    len <<- length(responses)
    for (i in c(1:length(responses[,1]))){
      query <- paste0("select name from fermers where ID='",responses[i,2],"';", sep = "")
      rs <- dbGetQuery(mydb, query)
      responses[i,len-2]<<-rs[,1]
      query <- paste0("select name from community where ID='",responses[i,4],"';", sep = "")
      rs <- dbGetQuery(mydb, query)
      responses[i,len-1]<<-rs[,1]
      query <- paste0("select Disaster_ID from disaster_event where ID='",responses[i,5],"';", sep = "")
      rs <- dbGetQuery(mydb, query)
      query <- paste0("select name from disaster where ID='",rs[,1],"';", sep = "")
      rs <- dbGetQuery(mydb, query)
      responses[i,len]<<-rs[,1]

    }
    if(exists("database")){
      database <<- rbind(cbind(responses[nrow(responses),c(len-2,len-1,len)],responses[nrow(responses),c("damages","loss")],total = responses[nrow(responses),"damages"]+responses[nrow(responses),"loss"]),database)
    }
    else{
      database <<- rbind(cbind(responses[nrow(responses),c(len-2,len-1,len)],responses[nrow(responses),c("damages","loss")],total = responses[nrow(responses),"damages"]+responses[nrow(responses),"loss"]))
    }
  }

  # get the general (not effect level) data from DB
  check_overall <- function(){

    mydb = connect_to_db()

    marz_name = formData()$marz
    rs = dbSendQuery(mydb, "select * from marz")
    rs = fetch(rs, n=-1)
    marz_id = as.matrix(rs["ID"])[which(rs["name"] == marz_name)]
    date = formData()$date
    disaster_name = formData()$disaster
    rs = dbSendQuery(mydb, "select * from disaster")
    rs = fetch(rs, n=-1)
    disaster_id = as.matrix(rs["ID"])[which(rs["name"] == disaster_name)]
    desc = formData()$description
    date_start = date[1]
    date_end = date[2]
    query <- paste0("INSERT INTO disaster_event (Date_start, Date_end,Marz_ID,Disaster_ID,Description)
                    VALUES('",date_start,"','",date_end,"',", marz_id,",",disaster_id,",'", desc,"')")
    rs = dbSendQuery(mydb, "select * from disaster_event")
    rs = fetch(rs, n=-1)
    if(!length(which(rs["Marz_ID"] == marz_id & rs["Disaster_ID"] == disaster_id & rs["Description"] == desc))){
      dbGetQuery(mydb, query)
    }
    rs = dbSendQuery(mydb, "select * from disaster_event")
    rs = fetch(rs, n=-1)
    dis_ev_id = as.matrix(rs["ID"])[which( rs["Marz_ID"] == marz_id & rs["Disaster_ID"] == disaster_id & rs["Description"] == desc)]


    com_name = formData()$community
    rs = dbSendQuery(mydb, "select * from community")
    rs = fetch(rs, n=-1)
    com_id = as.matrix(rs["ID"])[which(rs["name"] == com_name)]
    name = formData()$name
    rs = dbSendQuery(mydb, "select * from fermers")
    rs = fetch(rs, n=-1)

    if(!length(which(rs["name"] == name))){
      query <- paste0("INSERT INTO fermers (name) VALUES('",name,"')")
      dbGetQuery(mydb, query)
    }
    rs = dbSendQuery(mydb, "select * from fermers")
    rs = fetch(rs, n=-1)
    ferm_id = as.matrix(rs["ID"])[which(rs["name"] == name)]
    retList <- list("mydb" = mydb, "marz_id" = marz_id,"date_start" = date_start,"date_end"=date_end,
                    "disaster_id" = disaster_id,"desc" = desc,"dis_ev_id" = dis_ev_id,"com_id" =com_id,"ferm_id" = ferm_id)
    return(retList)

  }

  # script for defaults
  source("annual_default.R",local=TRUE)
  source("tree_default.R",local=TRUE)
  source("livestock_default.R",local=TRUE)
  source("land_default.R",local=TRUE)
  source("assets_default.R",local=TRUE)

  # script for customs
  source("annual_custom.R",local=TRUE)
  source("tree_custom.R",local=TRUE)
  source("livestock_custom.R",local=TRUE)

  # handling the input viewer table
  # output$view_results <- renderHtable({
  #   input$default || input$default_tree || input$default_land || input$default_asset || input$default_livestock || input$custom_crop || input$custom_tree || input$custom_livestock
  #   responses[nrow(responses),c(11:length(responses)-5,length(responses)-2,length(responses)-1,length(responses))]
  # })
  output$annual_inputs_table <- renderDataTable(
    colnames = c('Crop', 'Unit', 'Lost', 'Reduced', 'Replanting Possible?',
    'Share of reduction', 'Std yearly income', 'Replanting income',
    'Replanting cost','Recovery cost','Reason for custom','Losses','Damages',
    'Farmer name','Community','Disaster'),
    options=list(searching = FALSE, paging = FALSE, info=0,scrollX = T),{
      input$default || input$custom_crop
      responses[nrow(responses),c(6:length(responses))]
    })
  output$tree_inputs_table <- renderDataTable(
    options=list(searching = FALSE, paging = FALSE, info=0,scrollX = T),{
      input$default_tree || input$custom_tree
      responses[nrow(responses),c(6:length(responses))]
    })
  output$livestock_inputs_table <- renderDataTable(
    options=list(searching = FALSE, paging = FALSE, info=0,scrollX = T),{
      input$default_livestock || input$custom_livestock
      responses[nrow(responses),c(6:length(responses))]
    })
  output$assets_inputs_table <- renderDataTable(
    options=list(searching = FALSE, paging = FALSE, info=0,scrollX = T),{
      input$default_asset
      responses[nrow(responses),c(6:length(responses))]
    })
  output$lands_inputs_table <- renderDataTable(
    options=list(searching = FALSE, paging = FALSE, info=0,scrollX = T),{
      input$default_land
      responses[nrow(responses),c(6:length(responses))]
    })

  # designing the DataTable to show the Damage/Loss sum
  sketch = htmltools::withTags(table(
    tableHeader(c("N","Name","Community","Disaster","Damage","Loss","Total")),
    tableFooter(c("","","","",0,0,0))
  ))

  # continuing desining: copied from JavaScript lib
  opts <- list(dom = 'Bfrtip', buttons = list('colvis','print',list(extend='collection',text='Download',
                                              buttons = list('copy','csv','excel','pdf'))),
    footerCallback = JS(
      "function( tfoot, data, start, end, display ) {",
      "var api = this.api();",
      "$( api.column( 6 ).footer() ).html('AMD  '+",
      "api.column( 6).data().reduce( function ( a, b ) {",
      "return a + b;",
      "} )",
      ");",
      "$( api.column( 5 ).footer() ).html('AMD  '+",
      "api.column( 5).data().reduce( function ( a, b ) {",
      "return a + b;",
      "} )",
      ");",
      "$( api.column( 4 ).footer() ).html('AMD '+",
      "api.column( 4 ).data().reduce( function ( a, b ) {",
      "return a + b;",
      "} )",
      ");",
      "}")
  )

  # Show the previous responses (update with current response when default is clicked)
  output$table <- DT::renderDataTable(filter = 'top', container = sketch,extensions = 'Buttons',options = opts,{
    input$default || input$default_tree || input$default_land || input$default_asset || input$default_livestock || input$custom_crop || input$custom_tree || input$custom_livestock
    loadData()
  })
  # toggle Modal windows after submission to show confirmation page
  observeEvent(input$custom_crop,{
  toggleModal(session,"custom_inputs_crop", toggle = "close")
  })
  observeEvent(input$custom_tree,{
    toggleModal(session,"custom_inputs_tree", toggle = "close")
  })
  observeEvent(input$custom_livestock,{
    toggleModal(session,"custom_inputs_livestock", toggle = "close")
  })
  # the code below resets all inputs from the "Input data" tab to their defaults
  # HTML div tag was added to body to be able to refer all inputs with one ID
  observeEvent(
    input$default  || input$custom_crop,{
    shinyjs::reset("reset_inputs_annual")
  })
  observeEvent(
    input$default_tree || input$custom_tree,{
    shinyjs::reset("reset_inputs_tree")
  })
  observeEvent(
    input$default_livestock || input$custom_livestock,{
    shinyjs::reset("reset_inputs_livestock")
  })
  observeEvent(
    input$default_asset,{
    shinyjs::reset("reset_inputs_assets")
  })
  observeEvent(
    input$default_land,{
    shinyjs::reset("reset_inputs_land")
  })
  observeEvent(input$finish_entry,{
    shinyjs::reset("new_entry_box")
    })

  session$onSessionEnded(stopApp)
}
