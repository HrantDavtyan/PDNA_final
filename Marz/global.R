library("DT")
library("leaflet")
library("shinyTable")

total_loss = 0
total_damage = 0

marz_list <- sort(c("","Tavush","Lori","Ararat","Armavir","Aragatsotn",
                    "Kotayq","Shirak","Syunik","Gegharqunik","Vayots Dzor",""))
community_list <- sort(c("","Qarakert","Dalarik","Berd","Vayq","Basen","Poqr Vedi"))
disaster_list <- sort(c("","Hail","Frost","Drought","Flood"))
affect_list <- c(" ","Annual crops","Livestock","Trees and Bushes","Assets and Equipment","Infrastructure and Land")

crop_list <- sort(c("","Potato","Melon","Other"))
tree_bush_list <- sort(c("","Apple","Apricot","Other"))
livestock_list <- sort(c("", "Cow", "Poultry", "Other"))
land_list <- sort(c("", "Land1", "Land2", "Other"))
asset_list <- sort(c("","Asset1","Asset2","Other"))

fields <- c("date","community","disaster","name","affect","crop","unit","lost","reduced","reduction")

com_lats <-c(40.2470368,40.2246958,40.887446,39.6931693,40.7568223,39.9020156)
com_lngs <-c(43.8013529,43.8632369,45.372033,45.4518126,43.986125,44.5962953)

marz_lats <-c(39.202888,39.764200,39.913941,40.155463,40.250042,40.179186,40.259121,40.541021,40.838446,40.915227,40.969845)
marz_lngs <-c(46.479817,45.333753,44.720000,44.037245,45.146331,44.499103,44.179342,44.769015,43.914240,45.403239,44.490014)