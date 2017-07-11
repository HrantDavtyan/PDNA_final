output$contacts_map <- renderLeaflet({
  leaflet() %>%
    addTiles() %>%
    #addProviderTiles("Stamen.TonerLite",options = providerTileOptions(noWrap = TRUE)) %>%
    #setView(lat = 40.175576,lng = 44.513343, zoom = 7)
    addMarkers(lat=40.175576, lng=44.513343,popup="UN FAO office, Yerevan, Armenia")
})

output$mymap <- renderLeaflet({
    if(input$filter_disaster=="Annual crops"){
          mydb = connect_to_db()
          rs = dbSendQuery(mydb, paste0("SELECT Com_ID, damages, loss  from ","an_cr_entry"))
          rs = fetch(rs, n=-1)
          map_database <<- aggregate(rs,rs["Com_ID"],sum)
    }
  else if(input$filter_disaster=="Trees and Bushes"){
          total_damage <- 0
          mydb = connect_to_db()
          rs = dbSendQuery(mydb, paste0("SELECT Com_ID, damages, loss  from ","tree_entry"))
          rs = fetch(rs, n=-1)
          map_database <<- aggregate(rs,rs["Com_ID"],sum)
    }
  else if(input$filter_disaster=="Livestock"){
          total_damage <- 0
          mydb = connect_to_db()
          rs = dbSendQuery(mydb, paste0("SELECT Com_ID, damages, loss  from ","livestock_entry"))
          rs = fetch(rs, n=-1)
          map_database <<- aggregate(rs,rs["Com_ID"],sum)
    }
  else if(input$filter_disaster=="Lands and Infrastructure"){
          total_damage <- 0
          mydb = connect_to_db()
          rs = dbSendQuery(mydb, paste0("SELECT Com_ID, damages, loss  from ","land_entry"))
          rs = fetch(rs, n=-1)
          map_database <<- aggregate(rs,rs["Com_ID"],sum)
    }
  else if(input$filter_disaster=="Assets and Equipment"){
          total_damage <- 0
          mydb = connect_to_db()
          rs = dbSendQuery(mydb, paste0("SELECT Com_ID, damages, loss  from ","asset_entry"))
          rs = fetch(rs, n=-1)
          map_database <<- aggregate(rs,rs["Com_ID"],sum)
    }
  else{
          map_database <<- read.table(text = "",col.names = c("Com_ID","damages","loss"))
          for (effecto in c("an_cr_entry","tree_entry","asset_entry","land_entry","livestock_entry")){
            mydb = connect_to_db()
            rs = dbSendQuery(mydb, paste0("SELECT Com_ID, damages, loss FROM ",effecto))
            rs = fetch(rs, n=-1)
            map_database <<- rbind(map_database,rs)
          }
          map_database <<- aggregate(map_database,map_database["Com_ID"],sum)       
  }

  leaflet() %>%
    #addProviderTiles("Stamen.TonerLite",options = providerTileOptions(noWrap = TRUE)) %>%
    addProviderTiles("CartoDB.Positron") %>%
    addMarkers(lat = com_lats, lng = com_lngs,
               popup=paste0("Total Damage: AMD ",as.character(map_database[["damages"]]),br(),
                            "Total Loss: AMD ",as.character(map_database[["loss"]])),
               clusterOptions = markerClusterOptions()) %>%
    setView(lat = 40.175576,lng = 44.513343, zoom = 7)
})
