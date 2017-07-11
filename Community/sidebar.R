sidebar <- dashboardSidebar(
  sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                    label = "Search..."),
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Report", icon = icon("th"), tabName = "report",
             badgeLabel = "new", badgeColor = "green"),
    menuItem("Help", icon = icon("question"), tabName = 'help')
  )
)