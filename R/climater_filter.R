#' ClimateR Catalog Filter
#' @description Filter the climateR catalog based on a set of constraints
#' @param id The resource, agency, or catalog identifier
#' @param asset The subdataset or asset in a given resource
#' @param AOI an sf point or polygon to extract data for
#' @param startDate a start date given as "YYYY-MM-DD" to extract data for
#' @param endDate an end date given as "YYYY-MM-DD" to extract data for
#' @param varname variable name to extract (e.g. tmin)
#' @param model GCM model name generating 
#' @param ensemble The model ensemble member used to generate data
#' @param scenario A climate or modeling scenario used
#' @return data.frame
#' @export

climater_filter <- function(id = NULL,
                            asset = NULL,
                            AOI = NULL, 
                            startDate = NULL, 
                            endDate = NULL, 
                            varname = NULL, 
                            model = NULL, 
                            scenario= NULL,
                            ensemble = NULL) {
  
  variable <- description <- duration <- e <- s <- URL <- NULL
  
  if(is.null(id)){
    catalog = climateR::params
  } else {
    catalog = filter(climateR::params, id == !!id)
  }
  
  if (nrow(catalog) == 0) {
    stop("no data to filter.", call. = FALSE)
  }
  
  
  if(!is.null(asset)){
    catalog = filter(catalog, asset == !!asset)
  }
  
  if (nrow(catalog) == 0) {
    stop("no data to filter.", call. = FALSE)
  }
  
  ppts = c("pr", "ppt", "prcp")
  tmaxs = c('tmx', 'tmmx', 'tmax', "tasmax")
  tmins = c("tmn", "tmmn", 'tmin', "tasmin")

  ### 1  ---- varname filter
  if(!is.null(varname)){
    u <- unique(catalog$variable)
    
    if (all(varname %in% catalog$variable)) {
      catalog <- filter(catalog, varname %in% !!varname | variable %in% !!varname)
    } else {
      bad <- varname[!varname %in% u]
      
      m <- distinct(select(catalog, variable, description, units))
      
      stop("'", bad, "' not availiable parameter for '", catalog$id[1], "'. Try: \n\t",
           paste(">", paste0(m$variable, " [", m$units, "] (", m$long_name, ")"),
                 collapse = "\n\t"
           ),
           call. = FALSE
      )
    }
  }
 
  ### 2 ---- model filter
  if (!is.null(model)) {
    u <- unique(catalog$model)

    if (is.numeric(model)) {
      if (length(u) >= model) {
        model <- sample(unique(catalog$model), model, replace = FALSE)
      } else {
        stop("There are only ", length(u), " unique models.", call. = FALSE)
      }
    }

    if (all(model %in% catalog$model)) {
      catalog <- filter(catalog, model %in% !!model)
    } else {
      bad <- model[!model %in% u]

      m <- distinct(select(catalog, model, ensemble))

      stop("'", bad, "' not availiable model for '", catalog$id[1], "'. Try: \n\t",
        paste(">", paste0(m$model, " [", m$ensemble, "]"),
          collapse = "\n\t"
        ),
        call. = FALSE
      )
    }
  }

  ### 3 ---- date & scenario filter

  if(!is.null(startDate)){
    
    endDate = ifelse(is.null(endDate), as.character(startDate), as.character(endDate))
    
    tmp <- catalog %>% 
      mutate(
        s = do.call("rbind", strsplit(duration, "/"))[, 1],
        e = do.call("rbind", strsplit(duration, "/"))[, 2]
      ) %>% 
      mutate(e = ifelse(e == "..", as.character(Sys.Date()), e)) %>% 
      filter(as.Date(e) >= as.Date(startDate) & as.Date(s) <= as.Date(endDate))
    
    if(nrow(tmp) == 0){
      stop("Valid Date Range(s) includes: ", 
           paste("\n\t>", unique(paste0( catalog$duration, " [", catalog$scenario, "]")),
                 collapse = ""
           ), call. = FALSE)
    } else {
      catalog = tmp
    }
  } 
  
  if(!is.null(scenario)){
    if ("historical" %in% catalog$scenario) {
      scenario <- c("historical", scenario)
    }
    
    # if ("total" %in% catalog$scenario) {
    #   scenario <- c("total", scenario)
    # }
    
    if(!is.null(scenario)){
      catalog <- filter(catalog, scenario %in% !!scenario)
    }
  }
  
  ### ---- AOI filter
  if(!is.null(AOI)){
  
    gid = sapply(1:nrow(catalog), function(x) {
      suppressWarnings({
        tryCatch({
          nrow(terra::intersect(make_vect(cat = catalog[x, ]), project(AOI, crs(catalog$crs[x])))) > 0
        }, error = function(e) {
          FALSE
        })
        
      })
    })
    catalog = catalog[gid, ]
    
    if(nrow(catalog) == 0){
      stop("No data found in provided AOI.", call. = FALSE)
    } 
    
  }

  catalog[!duplicated(select(catalog, -URL)), ]
}
