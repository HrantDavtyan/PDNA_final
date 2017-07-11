library("DT")
library("shinyTable")

marz_list <- sort(c("","Tavush","Lori","Ararat","Armavir","Aragatsotn",
                    "Kotayq","Shirak","Syunik","Gegharqunik","Vayots Dzor",""))

community_list <- sort(c("","Qarakert","Dalarik","Berd","Vayq","Basen","Poqr Vedi"))
disaster_list <- sort(c("","Hail","Frost","Drought","Flood"))

crop_list <- sort(c("","Potato","Melon","Other"))
tree_bush_list <- sort(c("","Apple","Apricot","Other"))
livestock_list <- sort(c("", "Cow", "Poultry", "Other"))
land_list <- sort(c("", "Land1", "Land2", "Other"))
asset_list <- sort(c("","Asset1","Asset2","Other"))

fields <- c("date","community","marz","description","disaster","name","affect",
            "crop","unit","lost", "reduced","reduction","replanting",
            "trees","unit_tree","lost_tree","age_tree","replacement_tree","reduced_tree","recover_tree","reduction_tree",
            "land","unit_land","all_units_land","damaged_land","damage_land","replcost_land","reprcost_land",
            "asset","unit_asset","affected_asset","replcost_asset","reprcost_asset",
            "livestock","age_livestock","weight_livestock","lost_livestock","injured_livestock","injury_livestock"
            )

jscode <- "
shinyjs.collapse = function(boxid) {
$('#' + boxid).closest('.box').find('[data-widget=collapse]').click();
}
"
