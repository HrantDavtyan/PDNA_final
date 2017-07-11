observeEvent(input$default_livestock, {
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
  livestock = formData()$livestock
  age_livestock = formData()$age_livestock
  weight_livestock = formData()$weight_livestock
  lost_livestock = formData()$lost_livestock
  injured_livestock = formData()$injured_livestock
  injury_livestock = formData()$injury_livestock
  
  
  query <- paste("SELECT * FROM defaults WHERE marz_ID='", marz_id, "'", sep = "")
  rs <- dbGetQuery(mydb, query)
  O6 = rs["St_y_inc"][,1]
  N6 = rs["Rep_cost"][,1]
  P6 = rs["Rec_cost"][,1]
  
  G6 = lost_livestock
  H6 = injured_livestock
  I6 = injury_livestock
  
  
  loss = (H6*(O6*I6/100))+(H6*P6)+(G6*O6)
  damages =(G6*N6)
  
  
  
  query <- paste0("INSERT INTO livestock_entry (fermer_ID, effect,Com_ID,livestock_type,age,
                  Disaster_event_id,weight,units_lost,units_injured,red_share,
                  St_y_inc,Repl_cost,Rec_cost,damages,loss) 
                  VALUES(",ferm_id,",'",affect,"',", com_id,",'",livestock,"','",age_livestock,"',
                  ",dis_ev_id,",",weight_livestock,",",lost_livestock,",",injured_livestock,",",injury_livestock,",
                  ",O6,",",N6,",",P6,",",damages,",",loss,")")
  print(query)
  dbGetQuery(mydb, query)
  
  refresh_table(effecto="livestock_entry")
})