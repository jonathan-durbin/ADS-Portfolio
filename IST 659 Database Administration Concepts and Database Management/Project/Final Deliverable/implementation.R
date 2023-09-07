library(odbc)
library(DBI)
library(shiny)

ui = fluidPage(
  titlePanel("APD Database"),

  # Check out the views
  navlistPanel(
    tabPanel(
      "Views",
      selectInput(
        "view", "View:",
        c("All Vehicles" = "AllVehicles",
          "All Weapons and Vehicles" = "AllVehiclesWeapons",
          "All Warrants" = "AllWarrants")
      ),
      tableOutput("tbl")
    ),
    tabPanel(
      "Update Report",
      textInput(
        "reportid", "Report ID", placeholder = "Integer"),
      textInput(
        "personresponsible", "Person Responsible", placeholder = "Your ID"),
      textInput(
        "subjectfirstname", "Subject First Name", value = "default"),
      textInput(
        "subjectlastname", "Subject Last Name", value = "default"),
      textInput(
        "location", "Location", value = "default"),
      textInput(
        "weaponregistration", "Weapon Registration", value = "default"),
      textInput(
        "vehiclenumber", "Vehicle Number", value = "default"),
      actionButton(
        "submitReportUpdate", "Submit Update", placeholder = "Not Required"),
      textOutput("submitReportSuccess")
    ),
    tabPanel(
      "Data Questions",
      selectInput(
        "dq", "Data Question:",
        c("Larceny Report Number" = "larcenyreport",
          "Job Distribution" = "jobdistribution",
          "Vehicles Containing Weapons" = "vehicleweapons",
          "Report Type Distribution" = "reporttypedistribution",
          "Find All Judges" = "alljudges"
          )
      ),
      tableOutput("dqtbl")
    )
  )

)


server <- function(input, output, session) {
  output$tbl <- renderTable({
    conn <-
      dbConnect(
        odbc(),
        Driver = "ODBC Driver 17 for SQL Server",
        Server = "localhost",
        Database = "IST659-Project",
        Trusted_Connection = "Yes"
      )
    on.exit(dbDisconnect(conn), add = TRUE)

    dbGetQuery(
      conn,
      paste0("SELECT * FROM ", input$view, ";")
    )
  })

  observeEvent(
    input$submitReportUpdate,
    {
      conn <-
        dbConnect(
          odbc(),
          Driver = "ODBC Driver 17 for SQL Server",
          Server = "localhost",
          Database = "IST659-Project",
          Trusted_Connection = "Yes"
        )
      on.exit(dbDisconnect(conn), add = TRUE)

      dbExecute(
        conn,
        paste0("EXEC UpdateReport ",
               input$reportid, ', ',
               input$personresponsible, ', ',
               input$subjectfirstname, ', ',
               input$subjectlastname, ', ',
               input$location, ', ',
               input$weaponregistration, ', ',
               input$vehiclenumber, ';')
      )
    }
  )
  success <- eventReactive(input$submitReportUpdate, { "Executed Procedure!" })
  output$submitReportSuccess <- renderText({ success() })

  output$dqtbl <- renderTable({
    conn <-
      dbConnect(
        odbc(),
        Driver = "ODBC Driver 17 for SQL Server",
        Server = "localhost",
        Database = "IST659-Project",
        Trusted_Connection = "Yes"
      )
    on.exit(dbDisconnect(conn), add = TRUE)

    data.questions <- c(
      "larcenyreport" = "SELECT COUNT(ReportID) FROM AllReports WHERE ReportType = 'Larceny'",
      "jobdistribution" = "SELECT COUNT(*) AS [Total Jobs], Job FROM Person GROUP BY Job",
      "vehicleweapons" = "SELECT * FROM AllVehiclesWeapons",
      "reporttypedistribution" = "SELECT COUNT(*) AS [Total Report Types], ReportType FROM Report GROUP BY ReportType",
      "alljudges" = "SELECT * FROM Person WHERE Job = 'Judge'"
    )
    dbGetQuery(
      conn,
      paste0(data.questions[input$dq], ";")
    )
  })
}

shinyApp(ui, server)
