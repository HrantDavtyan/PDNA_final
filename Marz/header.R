header <- dashboardHeader(title = "Marz",
                          dropdownMenu(type = "messages",messageItem(from = "Ministry",
                                                                     message = "No compensastion this time!"),
                                       messageItem(from = "Community",
                                                   message = "How do I input?",icon = icon("question"),time = "13:45"),
                                       messageItem(from = "Support",
                                                   message = "The PDNA app is ready.",icon = icon("life-ring"),time = "2014-12-01")
                          ),
                          dropdownMenu(type = "notifications",notificationItem(text = "5 new users today",
                                                                               icon("users")),
                                       notificationItem(text = "12k seeds delivered",
                                                        icon("truck"),status = "success"),
                                       notificationItem(text = "Damage of 86%",
                                                        icon = icon("exclamation-triangle"),status = "warning")
                          ),
                          dropdownMenu(type = "tasks", badgeStatus = "warning",
                                       taskItem(value = 90, color = "green","Documentation"),
                                       taskItem(value = 17, color = "aqua","Project X"),
                                       taskItem(value = 75, color = "yellow","Server deployment"),
                                       taskItem(value = 80, color = "red","Overall project")
                          )
)