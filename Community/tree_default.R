observeEvent(input$default_tree, {
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
  crop = formData()$trees
  unit = formData()$unit_tree
  lost = formData()$lost_tree
  age = formData()$age_tree
  replacement_tree = formData()$replacement_tree
  
  reduced_tree = formData()$reduced_tree
  recover_tree = formData()$recover_tree
  share_red = formData()$reduction_tree
  
  query <- paste("SELECT * FROM defaults WHERE marz_ID='", marz_id, "'", sep = "")
  rs <- dbGetQuery(mydb, query)
  P6 = rs["St_y_inc"][,1]
  Q6 = rs["Rep_cost"][,1]
  R6 = rs["Rec_cost"][,1]
  
  G6 = lost
  H6 = replacement_tree
  I6 = reduced_tree
  K6 = share_red
  J6 = recover_tree
  
  loss = (I6*(P6*K6/100)*J6)+(R6*I6*J6)+(G6*H6*P6)
  damages =(G6*Q6)
  
  
  
  query <- paste0("INSERT INTO tree_entry (fermer_ID, effect,Com_ID,crop_name,measure_unit,
                  Disaster_event_id,age,lost,years_rep,units_red,years_rec,share_red,
                  St_y_inc,Rep_cost,Rec_cost,damages,loss) 
                  VALUES(",ferm_id,",'",affect,"',", com_id,",'",crop,"','",unit,"',
                  ",dis_ev_id,",",age ,",",lost,",",replacement_tree,",",reduced_tree,",",recover_tree,",",share_red,",
                  ",P6,",",Q6,",",R6,",",damages,",",loss,")")
  print(query)
  dbGetQuery(mydb, query)
  
  refresh_table(effecto="tree_entry")
})