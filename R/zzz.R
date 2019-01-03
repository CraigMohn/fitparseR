
.onLoad <- function(libname, pkgname) {

  #  set flag that we are loaded, not called yet
  op <- options()
  op.fitparseR <- list(
    fitparseR.conda.checked = FALSE
  )
  toset <- !(names(op.fitparseR) %in% names(op))
  if (any(toset)) options(op.fitparseR[toset])

  invisible()
}
