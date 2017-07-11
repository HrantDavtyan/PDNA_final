observeEvent(input$default, {
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
  crop = formData()$crop
  unit = formData()$unit
  lost = formData()$lost
  reduced = formData()$reduced
  share_red = formData()$reduction
  if(formData()$replanting == "Yes"){
    repl = 1
  }
  else{
    repl = 0
  }
  
  query <- paste("SELECT * FROM defaults WHERE marz_ID='", marz_id, "'", sep = "")
  rs <- dbGetQuery(mydb, query)
  N6 = rs["St_y_inc"][,1]
  P6 = rs["Rep_inc"][,1]
  O6 = rs["Rep_cost"][,1]
  Q6 = rs["Rec_cost"][,1]
  
  F6 = formData()$lost
  H6 = formData()$reduced
  I6 = formData()$reduction
  G6 = formData()$replanting
  tmp = 0
  if(G6 == "Yes"){
    tmp = F6*O6
  }
  loss = (F6*N6-P6)+(H6*(N6*I6/100))+(H6*Q6)+tmp
  damages = 0
  
  
  query <- paste0("INSERT INTO an_cr_entry (fermer_ID, effect,Com_ID,crop_name,measure_unit,lost,reduced,
                  Disaster_event_id,Rep_pos,share_red,St_y_inc,Rep_inc,Rep_cost,Rec_cost,loss,damages) 
                  VALUES(",ferm_id,",'",affect,"',", com_id,",'",crop,"','",unit,"',",lost,",",reduced ,",
                  ",dis_ev_id,",",repl,",",share_red,",",N6,",",P6,",",O6,",",Q6,",",loss,",",damages,")")
  dbGetQuery(mydb, query)
  
  refresh_table(effecto="an_cr_entry")
})