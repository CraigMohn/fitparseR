#' fitparseR: A package for reading garmin .fit files
#'
#' The fitparseR package uses reticulate and jsonlite to wrap
#'   the python fitparse package, which seems to be kept more
#'   current than the native R solutions for processing .fit
#'   files
#'
#' @section read .fit file:
#'   \link{get_fit_dfs}
#'
#' @import reticulate jsonlite
#'
#' @name fitparseR
NULL

###  make the R checker happy
tedious <- utils::globalVariables(c("readff", "message_df"))
