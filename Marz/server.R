library("RMySQL")
mydb <<- NULL

# function for making connection to DB
connect_to_db<-function(){

  if(is.null(mydb)){
    all_cons <- dbListConnections(MySQL())
    for(con in all_cons)
      dbDisconnect(con)

    mydb <<- dbConnect(MySQL(), user='pdnaahos_hrant',password='DiliJan7',dbname='pdnaahos_pdna', host='pdna.a2hosted.com')
    #mydb <<- dbConnect(MySQL(), user='root',dbname='pdna', host='127.0.0.1')
  }
  return (mydb)
}

function(input, output,session) {
  source("maps.R",local=TRUE)

  # server for showing default value inputs
  output$ui_inputs <- renderUI({
    if (is.null(input$default_affect))
      return()

    # Depending on input$default_affect, we'll generate a different
    # UI component and send it to the client.
    switch(input$default_affect,
		"Trees and Bushes" = source("default_trees.R",local=TRUE)[1],
		"Annual crops" = source("default_annual.R",local=TRUE)[1],
    "Livestock" = source("default_livestock.R",local=TRUE)[1])
  })
  # server for default value updating
  observeEvent(input$update_defaults, {
    mydb = connect_to_db()
    query <- paste0("SELECT ID FROM marz WHERE name='",input$default_marz,"';")
    print(query)
    marz_ID <- dbGetQuery(mydb, query)
    print(marz_ID)
    query <- paste0("UPDATE defaults SET St_y_inc=",input$styield,", Rep_inc=",input$repyield,
                    ", Rep_cost=",input$repcost,", Rec_cost=",input$reccost," WHERE marz_ID=",marz_ID)
    print(query)
    dbGetQuery(mydb, query)
  })

  # assigning text from for list to a variable name in global environment
  # assign(paste(effecto),rs,envir=globalenv())

  # function for getting data and saving into local memory
  get_data <-function(effecto){
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
  }
  # function for downloading data from server and constructing a dataframe from it
  download_data <- function(effecto){
    get_data(effecto)
    write.csv(responses,file=paste0(effecto,".csv"))
  }
  # server for Download buttons
  observeEvent(input$download_crop,{download_data("an_cr_entry")})
  observeEvent(input$download_tree,{download_data("tree_entry")})
  observeEvent(input$download_livestock,{download_data("livestock_entry")})
  observeEvent(input$download_asset,{download_data("asset_entry")})
  observeEvent(input$download_land,{download_data("land_entry")})

  # calculating values of infoboxes
  total_damage <- 0
  total_loss <- 0
  for (effecto in c("an_cr_entry","tree_entry","asset_entry","land_entry","livestock_entry")){
    mydb = connect_to_db()
    rs = dbSendQuery(mydb, paste0("SELECT *  from ",effecto))
    rs = fetch(rs, n=-1)
    total_damage = total_damage + sum(rs["damages"])
    total_loss = total_loss +sum(rs["loss"])
  }
  output$total_damage_box <-renderInfoBox({
    infoBox("","Total Damages",total_damage, color = "light-blue")
  })
  output$total_loss_box <-renderInfoBox({
    infoBox("","Total Losses", total_loss, color = "light-blue")
  })

  #review tab functionality
  output$table <- DT::renderDataTable(filter = 'top',{
    get_data(input$select_effect)
    r_l<-length(responses)
    responses[c(2,6:8,(r_l-9):(r_l-5))]
  })
  observeEvent(input$edit_data,{
    selected_rows<<-input$table_rows_selected
    print(responses[selected_rows,c(1,8:11)])
    r_l<-length(responses)
    output$edit_table<-renderHtable({responses[selected_rows,c((r_l-9):(r_l-5))]})
  })
  observeEvent(input$submit_edit_table,{
    modified <<-input$edit_table
    print(modified)
    mydb = connect_to_db()
    query <- paste0("UPDATE ",input$select_effect," SET reason='",modified["reason"],"'"," WHERE ID=",responses[selected_rows,"ID"])
    print(query)
    dbGetQuery(mydb, query)
  })

  # toggle edit table Modal window after submission to show confirmation page
  observeEvent(input$submit_edit_table,{
    toggleModal(session,"edit_table_modal", toggle = "close")
  })
  session$onSessionEnded(stopApp)
}
