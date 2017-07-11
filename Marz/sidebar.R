sidebar <- dashboardSidebar(
  sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                    label = "Search..."),
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Review", icon = icon("th"), tabName = "review",
             badgeLabel = "new", badgeColor = "green"),
    menuItem("Update Defaults", icon = icon("bullseye"), tabName = 'defaults'),
    menuItem("HRNA", icon = icon("database"), tabName = 'test'),
    menuItem("Help", icon = icon("question"), tabName = 'help')
  )
)