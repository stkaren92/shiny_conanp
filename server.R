# Define server logic for slider examples
shinyServer(function(input, output, session){
  
    observeEvent(input$go_to_tab2, {
        updateTabsetPanel(session, "tabs", selected = "Distribución de maíces")
    })
    
    points_mod <- select_group_server(
        id = "my_filters",
        data = reactive(TableL),
        vars = reactive(c("RazaPrimaria", "RegionCONANP", "ANP_RPC_CONANP", 
                 "CategoriaConservacion",
                 "CategoriaANP","AnioColecta", "Estado"))
    )
    
    output$points <- reactable::renderReactable({
        req(points_mod())
        reactable::reactable(points_mod())
    })

    output$mymap <- renderLeaflet({
        req(points_mod())
        Goldberg <- points_mod()
        leaflet(data = Goldberg) %>%
            addTiles() %>%
            addCircleMarkers(~longitude, ~latitude, radius = 4, 
                             popup = paste(sep = "",
                                           "Raza primaria = ",Goldberg$RazaPrimaria,"<br/>",
                             "Número de Beneficiario = ",Goldberg$NumeroBeneficiarios, "<br/>",
                             "<b><a href='https://www.biodiversidad.gob.mx/diversidad/alimentos/maices/razas-de-maiz'>Información sobre la Raza de maíz</a></b>"),
                             clusterOptions = markerClusterOptions())
    })
    
    output$TablaF <- DT::renderDataTable({
        DT::datatable(points_mod() %>% 
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
            writexl::write_xlsx(points_mod() , file)
        }
    )
    
  })