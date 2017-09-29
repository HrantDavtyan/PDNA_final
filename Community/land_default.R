observeEvent(input$default_land, {
  a <- check_overall()
  mydb = a$mydb
  marz_id = a$marz_id
  date_start = a$date_start
  date_end = a$date_end
  disaster_id = a$disaster_id
  desc = a$desc
  dis_ev_id = a$dis_ev_id
  com_id = a$com_id 
  ferm_id = a$ferm_id
  
  affect = input$type_tab
  land = formData()$land
  unit = formData()$unit_land
  damaged_units = formData()$damaged_land
  lost_units = formData()$lost_land
  repl_cost = formData()$replcost_land
  repr_cost = formData()$reprcost_land
  
  # query <- paste("SELECT * FROM Defaults WHERE marz_ID='", marz_id, "'", sep = "")
  # rs <- dbGetQuery(mydb, query)
  # CHECK START
  # P6 = rs["St_y_inc"][,1]
  # Q6 = rs["Rep_cost"][,1]
  # R6 = rs["Rec_cost"][,1]

  damages =lost_units*repl_cost + damaged_units*repr_cost
  loss = 0
  
  
  
  query <- paste0("INSERT INTO land_entry (fermer_ID, effect,Com_ID,land,measure_unit,Disaster_event_id,
                  damaged_units,lost_units,repl_cost,repr_cost,damages,loss) 
                  VALUES(",ferm_id,",'",affect,"',", com_id,",'",land,"','",unit,"',",dis_ev_id,",
                  ",damaged_units,",",lost_units,",",repl_cost,",",repr_cost,",",damages,",",loss,")")
  print(query)
  dbGetQuery(mydb, query)
  
  refresh_table(effecto="land_entry")
})