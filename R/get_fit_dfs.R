#' read gps fit data files
#'
#' \code{get_fit_dfs} reads a gps .fit files using python
#'  and put into session, data record, and event dataframes
#'
#'
#' @param fitfilename name (including file path) of .fit file
#'
#' @return a list of three dataframes:  \eqn{session},
#'     \eqn{records}and \eqn{events}
#'
#' @export
get_fit_dfs <- function(fitfilename) {

  if (!getOption("fitparseR.conda.checked")) {
    set_fitparse_conda()
    options(list(fitparseR.conda.checked = TRUE))
  }
  reticulate::use_condaenv("r-reticulate", required = TRUE)
  pyfuncs <- paste(system.file(package = "fitparseR"),
                   "readfitfile.py", sep = "/")
  reticulate::source_python(pyfuncs, convert = TRUE)

  fitfile <- readff(fitfilename)

  tfile <- tempfile()

  message_df(fitfile, outfile = tfile, msgtype = "session",
             appendunits = FALSE, fromR = TRUE)
  session <- listofcols_to_df(jsonlite::fromJSON(tfile))

  message_df(fitfile, outfile = tfile, fromR = TRUE)
  records <- listofcols_to_df(jsonlite::fromJSON(tfile))

  message_df(fitfile, outfile = tfile, msgtype = "event",
             appendunits = FALSE, fromR = TRUE)
  events <- listofcols_to_df(jsonlite::fromJSON(tfile))

  return(list(session = session, records = records, events = events))
}

listofcols_to_df <- function(listofcolumns)  {
  cnames <- names(listofcolumns)
  vvv <- list()
  for (vlist in listofcolumns) {
    vlist[lengths(vlist) == 0] <- NA
    vvv[[length(vvv) + 1]] <- unlist(vlist)
  }
  names(vvv) <- cnames
  return(as.data.frame(vvv, stringsAsFactors = FALSE))
}

set_fitparse_conda <- function()  {
  message("setting up conda ")
  reticulate::use_condaenv("r-reticulate", required = TRUE)
  reticulate::py_install(c("pandas", "python-fitparse"))
  invisible()
}
