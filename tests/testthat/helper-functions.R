
# Helper to test argument order
abc <- function(a = "", b = "", c = "") {
  cat("a: <", a, ">\n", sep = "")
  cat("b: <", b, ">\n", sep = "")
  cat("c: <", c, ">\n", sep = "")
  invisible(NULL)
}
