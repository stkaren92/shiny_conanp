# Define server logic for slider examples
shinyServer(function(input, output, session){
  
    observeEvent(input$go_to_tab2, {
        updateTabsetPanel(session, "tabs", selected = "Distribución de maíces")
    })
    
    points <- callModule(
        module = selectizeGroupServer,
        id = "my_filters",
        data = TableL,
        vars = c("RazaPrimaria", "RegionCONANP", "ANP_RPC_CONANP", 
                 "CategoriaConservacion",
                 "CategoriaANP","AnioColecta", "Estado"), 
        inline = FALSE
    )

  
    output$mymap <- renderLeaflet({
        Goldberg <- points()
        leaflet(data = Goldberg) %>%
            addTiles() %>%
            addCircleMarkers(~longitude, ~latitude, radius = 4, 
                             popup = paste(sep = "",
                                           "Raza primaria = ",Goldberg$RazaPrimaria,"<br/>",
                             "Número de Beneficiario = ",Goldberg$NumeroBeneficiario, "<br/>",
                             "<b><a href='https://www.biodiversidad.gob.mx/diversidad/alimentos/maices/razas-de-maiz'>Información sobre la Raza de maíz</a></b>"),
                             clusterOptions = markerClusterOptions())
    })
    
    output$TablaF <- DT::renderDataTable({
        DT::datatable(points() %>% 
                          dplyr::select("Estado", "Municipio",
                                        "Region CONANP" = "RegionCONANP",
                                        "Área de Conservación" = "ANP_RPC_CONANP",
                                        "Raza primaria" = "RazaPrimaria",
                                        "Núm. Beneficiados" = "NumeroBeneficiarios"))
    })
    
    #Para la tabla en csv 
    
    output$downloadData <- downloadHandler(
        filename = function() { paste("Tabla", '.xlsx', sep = '') },
        content = function(file) {
            writexl::write_xlsx(points() , file)
        }
    )
    
  })