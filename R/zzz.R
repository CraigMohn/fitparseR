
.onLoad <- function(libname, pkgname) {

  #  set flag that we are loaded, not called yet
  op <- options()
  op.fitparser <- list(
    fitparseR.conda.checked = FALSE
  )
  toset <- !(names(op.fitparser) %in% names(op))
  if (any(toset)) options(op.fitparser[toset])

  invisible()
}
