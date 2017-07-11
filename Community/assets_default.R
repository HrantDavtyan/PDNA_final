observeEvent(input$default_asset, {
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
  asset = formData()$asset
  unit_asset = formData()$unit_asset
  affected_asset = formData()$affected_asset
  replcost_asset = formData()$replcost_asset
  reprcost_asset = formData()$reprcost_asset
  
  F7 = affected_asset
  G7 = replcost_asset
  H7 = reprcost_asset
    
  loss = 0
  damages = (F7*G7)+(F7*H7)
  
  
  
  query <- paste0("INSERT INTO asset_Entry (fermer_ID, effect,Com_ID,asset_type,measure_unit,
                  Disaster_event_id,units_affected,repl_cost,repr_cost,damages,loss) 
                  VALUES(",ferm_id,",'",affect,"',", com_id,",'",asset,"','",unit_asset,"',
                  ",dis_ev_id,",",affected_asset ,",",replcost_asset,",",reprcost_asset,",
                  ",damages,",",loss,")")
  print(query)
  dbGetQuery(mydb, query)
  
  refresh_table(effecto="asset_entry")
})