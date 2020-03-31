#' read gps fit data files
#'
#' \code{get_fit_dfs} reads a gps .fit files using call to python fitparse
#'  and put into session, data record, and event dataframes
#'
#'
#' @param fitfilename name (including file path) of .fit file
#' @param checkconda logical, check conda environment for packages
#' @param requiredVars vector of variable names which will be generated as NA
#'   if they are not already in the fit data records
#'
#' @return a list of three dataframes:  \eqn{session},
#'     \eqn{records}and \eqn{events}
#'
#' @export
get_fit_dfs <- function(fitfilename,checkconda=TRUE,
                         requiredVars) {

  if (checkconda & !getOption("fitparseR.conda.checked")) {
    set_fitparse_conda()
    options(list(fitparseR.conda.checked = TRUE))
  }
  reticulate::use_condaenv("r-reticulate", required = TRUE)
  pyfuncs <- paste(system.file(package = "fitparseR"),
                   "readfitfile.py", sep = "/")
  reticulate::source_python(pyfuncs, convert = TRUE)

  fitfile <- readff(fitfilename)

  #  tfile <- tempfile()
  #  message_df(fitfile, outfile = tfile, fromR = TRUE, dropmissing=FALSE)
  #  records <- listofcols_to_df(jsonlite::fromJSON(tfile))
  #  message_df(fitfile, outfile = tfile, msgtype = "session",
  #             appendunits = FALSE, fromR = TRUE, dropmissing=FALSE)
  #  session <- listofcols_to_df(jsonlite::fromJSON(tfile))
  #  message_df(fitfile, outfile = tfile, msgtype = "event",
  #             appendunits = FALSE, fromR = TRUE)
  #  events <- listofcols_to_df(jsonlite::fromJSON(tfile))
  records <- listofcols_to_df(
      message_df(fitfile, outfile = NULL, fromR = TRUE, dropmissing=FALSE))
  session <- listofcols_to_df(
      message_df(fitfile, outfile = NULL, msgtype = "session",
                 appendunits = FALSE, fromR = TRUE, dropmissing=FALSE))
  events <- listofcols_to_df(
      message_df(fitfile, outfile = NULL, msgtype = "event",
                 appendunits = FALSE, fromR = TRUE))
  if (!missing(requiredVars)) records <- addVars(records,requiredVars)

  if (nrow(session) != 1) stop(paste0("session dataframe error, nrows=",nrow(session)))

  return(list(session = session, records = records, events = events))
}

listofcols_to_df <- function(listofcolumns)  {

  cnames <- names(listofcolumns)
  vvv <- list()
  onames <- numeric(0)
  for (i in seq_along(listofcolumns)) {
    vlist <- listofcolumns[[i]]
    if (length(unlist(vlist)) > 0) {
      nsubvars <- max(c(lengths(vlist),1))
      if (!lubridate::is.POSIXct(vlist) ) vlist[lengths(vlist) == 0] <- list(rep(NA,nsubvars))
      if (min(lengths(vlist)) != max(lengths(vlist)))
         stop("bad length of multivalued variable ",cnames[i],".  min, max = ",
              min(lengths(vlist)),"  ",max(lengths(vlist)))

      if (nsubvars == 1) {
        vvv[[length(vvv) + 1]] <- unlist(vlist)
        onames <- c(onames,cnames[[i]])
      } else {
        vvec <- unlist(vlist)
        for (j in 1:nsubvars) {
          vvv[[length(vvv) + 1]] <- vvec[j + (seq(1,length(lengths(vlist)))-1)*nsubvars]
          onames <- c(onames,paste0(cnames[i],"_",j))
        }
      }
    }
  }
  names(vvv) <- onames
  dfret <- as.data.frame(vvv, stringsAsFactors = FALSE)
  #  the key timestamp variable should be POSIXct
  if ("timestamp" %in% cnames) {
    dfret$timestamp.s <- as.POSIXct(dfret$timestamp,
                                    format = "%Y-%m-%dT%H:%M:%OSZ",
                                    tz = "UTC")
  }
  return(dfret)
}
addVars <- function(df,varlist)  {
  for (v in varlist) {
    if (! v %in% names(df)) df[[v]] <- NA
  }
  return(df)
}

set_fitparse_conda <- function()  {
  message("checking conda ")
  reticulate::use_condaenv("r-reticulate", required = TRUE)
  reticulate::py_install(c("pandas", "python-fitparse"))
  message("done checking conda")
  invisible()
}
