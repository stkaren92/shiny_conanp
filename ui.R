# Define UI for the application
shinyUI(fluidPage(
    # Navbar layout with two pages
    navbarPage(
        title = div(
            tags$img(src = "logo_conanp.png", height = "30px", style = "margin-right: 10px;"),
            tags$img(src = "logo_conabio.png", height = "30px")
        ),
        windowTitle = "PROMAC",
        id = "tabs",
        theme = shinytheme("flatly"),
            
            # Primera página: Resumen con imagen
            tabPanel("Resumen",
                     fluidPage(
                         titlePanel("Programa de Maíz Criollo (PROMAC)"),
                         sidebarLayout(
                             sidebarPanel(
                                 h4("Informacion General sobre el ", 
                                    tags$a(href = "https://www.gob.mx/conanp/acciones-y-programas/maiz-criollo", "PROMAC", target = "blank")), 
                                # tags$img(src = "totoro.jpg", 
                                #          alt = "Imagen del programa PROMAC", 
                                #          width = "100%", height = "auto"),
                                
                                #carrusle con slickR
                                
           tags$style(HTML("
                      .slick-slide img {
                                        width: auto;
                                        height: auto;
                                        max-width: 100%;    /* Ajusta el ancho al contenedor */
                                        max-height: 100%;   /* Ajusta la altura al contenedor */
                                        objetct-fit: contain; /* Cubre el contenedor */
                                        display: block;
                                        margin: auto;
                                      }
                                      .slick-slider {
                                        aspect-ratio: auto;
                                        height: 400px;      /* Altura fija del carrusel */
                                        max-width: auto;   /* Ancho máximo del carrusel */
                                        margin: auto;       /* Centra el carrusel */
                                        overflow: hidden;   /* Oculta cualquier contenido desbordado */
                                      }
                                         ")),
                                
                                slickR(
                                    obj = list("maiz1.png", "maiz2.png", 
                                               "maiz3.jpg", "maiz4.jpg", 
                                               "maiz5.jpg", "maiz6.jpg")
                                    ) + settings(
                                        autoplay = TRUE,
                                        autoplaySpeed = 3000, # Milisegundos
                                        dots = TRUE,           # Mostrar indicadores
                                        arrows = TRUE         # Mostrar flechas
                                    )
                            #    uiOutput("rotating_image"),
                            #     position = "left",
                            #     fluid = TRUE
                             ),
                             mainPanel(
                                 # h3("Resumen del PROMAC"),
                                 tags$p(strong("El Programa de Conservación de Maíz Criollo (",
                                               tags$a(href = "https://www.gob.mx/conanp/acciones-y-programas/maiz-criollo", "PROMAC-CONANP", target = "blank"),
                                               ") 2009-2018"), "tuvo como objetivo promover la conservación y recuperación de razas y variedades de maíces nativos y sus parientes silvestres en sus entornos naturales, empleando los diferentes sistemas de cultivo de acuerdo a las regiones y costumbres. Las y los beneficiarios del programa fueron quienes se han dedicado al cultivo de los", strong("maíces criollos o nativos"),  "a lo largo del tiempo, principalmente para autoconsumo, lo que ha favorecido la diversidad genética, que representa un legado para la humanidad.",
                                        style = "font-size: 22px;"),
                                 tags$p("Este programa alentó a las agricultoras y agricultores a continuar con el cultivo y preservación de sus razas de maíces nativos, aprovechando los terrenos o áreas destinados para el cultivo dentro de las Áreas Naturales Protegidas (ANP) y Regiones Prioritarias para la Conservación (RPC).",
                                        style = "font-size: 22px;"),
                                 tags$p("Los datos que se muestran, en el mapa ( ver la pestaña", actionLink("go_to_tab2","Distribución de Maíces"), "), provienen de los apoyos realizados por el ", strong("Pago por Conservación ", em("in situ")),
                                        ", que consistió en un estímulo económico a quienes sembraron maíces nativos. En la visualización, se pueden consultar las razas de maíces nativos que se sembraron en las ANP y RPC durante la operación del programa. El PROMAC se ejecutó ininterrumpidamente de 2009 a 2015, a partir de 2016 hasta 2018 el PROMAC se incorporó al Programa de Conservación de Especies en Riesgo (PROCER) en el componente de Maíz Criollo. Actualmente la CONANP continúa apoyando estas actividades a través del Programa de Conservación para el Desarrollo Sostenible (PROCODES), mediante el concepto de pago por conservación de la agrobiodiversidad (2019-2024).",
                                        style = "font-size: 22px;"),
                                 tags$p("El proyecto", 
                                        tags$a(href = "https://www.biodiversidad.gob.mx/diversidad/proyectos/acp", "Acciones complementarias al Programa de Conservación de Maíz Criollo (ACP)", target = "blank"),
                                        " (2012-2023), financiado por CONANP y ejecutado por CONABIO formó parte de una estrategia integral que ha sido clave en la sistematización de estos apoyos", tags$a(href = "https://www.biodiversidad.gob.mx/diversidad/proyectos/acp", "(PROMAC).", target = "blank"), style = "font-size: 22px;"),
                             )
                         )
                     )
            ), # fin de pagina 1
            
            # Segunda página: Análisis de datos con imagen
            tabPanel("Distribución de maíces",
                     fluidPage(
                         tags$head(
                             tags$style(HTML("
                     .sidebar, .main-panel {
                         height: calc(100vh - 100px); /* Ajustar altura menos el título */
                     }
                     .sidebar {
                         overflow-y: auto; /* Scroll si es necesario */
                     }
                     .main-panel {
                         overflow-y: hidden; /* Sin scroll en el mainPanel */
                     }
                 "))
                         ),
                         
                         # Título de la segunda página
                         titlePanel("Razas de maíz del PROMAC"),
                         
                         sidebarLayout(
                             sidebarPanel(
                                 select_group_ui(
                                     id = "my_filters",
                                     params = list(
                                         RegionCONANP = list(inputId = "RegionCONANP", label = "Región CONANP:"),
                                         ANP_RPC_CONANP = list(inputId = "ANP_RPC_CONANP", label = "Nombre Área de Conservación:"),
                                         CategoriaConservacion = list(inputId = "CategoriaConservacion", label = "Categoría de Conservación:"),
                                         CategoriaANP = list(inputId = "CategoriaANP", label = "Categoria Áreas Naturales Protegidas:"),
                                         Estado = list(inputId = "Estado", label = "Estado:"),
                                         RazaPrimaria = list(inputId = "RazaPrimaria", label = "Raza Primaria:"),
                                         AnioColecta = list(inputId = "AnioColecta", label = "Año de Apoyo:")
                                     ),  
                                     vs_args = list(disableSelectAll = FALSE,
                                                    showValueAsTags = TRUE,
                                                    width = "100%"),
                                     inline = FALSE
                                 ),
                                 br(),
                                 downloadButton('downloadData', 'Download como xlsx'),
                                 br(),
                                 br(),
                                 h4("Informacion General sobre el ", tags$a(href = "https://www.gob.mx/conanp/acciones-y-programas/maiz-criollo", "PROMAC")),
                                 width = 2
                             ),
                             
                             mainPanel(
                                 fluidRow(
                                     shinydashboardPlus::box(
                                         width = 12,
                                         style = "height: 50vh;",  # 50% de la altura de la ventana del navegador
                                         leafletOutput("mymap", height = "100%")
                                     ),
                                     shinydashboardPlus::box(
                                         width = 12,
                                         style = "height: 40vh;",  # 40% de la altura de la ventana del navegador
                                         DT::dataTableOutput(outputId = "TablaF")
                                     )
                                 ),
                                 width = 10
                             )
                         )
                     )
            )
    ) # Fin navbarPage
))
