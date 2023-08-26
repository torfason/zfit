
context("zfunction")

test_that("zfunction works", {

  # Define the zgrep function, which is our test case
  zgrep <- zfunction(grep, x)

  # Run grep and zgrep on the same input (apart from order)
  char_vector <- rownames(mtcars)
  r.grep  <- grep("ll", char_vector, value=TRUE)
  r.zgrep <- zgrep(char_vector, "ll", value=TRUE)
  expect_equal(r.zgrep, r.grep)

})

test_that("zfunction curly notation works", {

  the_param_name <- "x"

  # Define the zgrep function, which is our test case
  zgrep <- zfunction(grep, x)
  zgrep_constant       <- zfunction(grep, "x")
  zgrep_constant_named <- zfunction(grep, x = "x")
  zgrep_curly          <- zfunction(grep, {the_param_name})
  zgrep_curly_named    <- zfunction(grep, x = {the_param_name})

  # These shouls all be equal
  expect_equal(zgrep, zgrep_constant)
  expect_equal(zgrep, zgrep_constant_named)
  expect_equal(zgrep, zgrep_curly)
  expect_equal(zgrep, zgrep_curly_named)
})

context("zfold")

test_that("zfold works", {

  abc() |> expect_output(".*a.*b.*c")

  hi <- "hi"

  "hi" |> abc() |> expect_output("a.*hi.*b")

  bac_function <- zfunction(abc, b)
  bac_fold     <- zfold(abc, b)

  # function first, constant and variable
  "hi" |> bac_function() |> expect_output("b.*hi.*c")
  hi   |> bac_function() |> expect_output("b.*hi.*c")

  # then fold, constant and variable
  "hi" |> bac_fold() |> expect_output("b.*hi.*c")
  hi   |> bac_fold() |> expect_output("b.*hi.*c")


  # # Define the zgrep function, which is our test case
  # zgrep <- zfold(grep, x)
  #
  # # Run grep and zgrep on the same input (apart from order)
  # char_vector <- rownames(mtcars)
  # r.grep  <- grep("ll", char_vector, value=TRUE)
  # r.zgrep <- zgrep(char_vector, "ll", value=TRUE)
  # expect_equal(r.zgrep, r.grep)

})

test_that("zfold curly notation works", {

  the_param_name <- "x"

  # Define the zgrep function, which is our test case
  zgrep <- zfold(grep, x)
  zgrep_constant       <- zfold(grep, "x")
  zgrep_constant_named <- zfold(grep, x = "x")
  zgrep_curly          <- zfold(grep, {the_param_name})
  zgrep_curly_named    <- zfold(grep, x = {the_param_name})

  # These shouls all be equal
  expect_equal(zgrep, zgrep_constant)
  expect_equal(zgrep, zgrep_constant_named)
  expect_equal(zgrep, zgrep_curly)
  expect_equal(zgrep, zgrep_curly_named)
})

context("zfold generics")

test_that("zfold on S3 generic print works", {
  if (requireNamespace("tibble") && getRversion() >= "4.1.0") {
    # Flip order of print generic, but still dispatch to print.tbl_df
    ztbl_print <- zfold(print, "n", x_not_found = "ok")
    cartibble <- tibble::tibble(cars)

    # Print 7 rows, leaving 43 unprinted
    7 |> ztbl_print(cartibble) |>
      expect_output("43 more rows")

    # Print 7 rows, leaving 43 unprinted
    13 |> ztbl_print(cartibble) |>
      expect_output("37 more rows")
  }

})

test_that("zfold on well-behaved S3 generics works", {
  if (getRversion() >= "4.1.0") {

    dispatch           <- function(x, y) { UseMethod("dispatch") }
    dispatch.default   <- function(x, y) { paste("default", x, y) }
    dispatch.numeric   <- function(x, y) { paste("numeric", x, y) }
    dispatch.character <- function(x, y) { paste("character", x, y) }
    # dispatch(1, "b")
    # dispatch("a", 2)

    zdispatch_fun <- zfunction(dispatch, y)
    zdispatch_fld <- zfold(dispatch, y)

    # Incorrect dispatch to numeric (1:3 first arg)
    expect_match( 1:3 |> zdispatch_fun("a"), "numeric")

    # Correct dispatch to character ("a" first arg)
    expect_match( 1:3 |> zdispatch_fld("a"), "character")
  }
})

test_that("zfold on poorly-behaved S3 generics doesn't work", {
  if (getRversion() >= "4.1.0") {
    # Flip order of t.test generic, but still dispatch t.test.formula
    zgt.test <- zfold(t.test, "data", x_not_found = "ok")

    # t.test.formula changes the name of the first argument,
    # whics breaks even folded dispatch.
    t.test(mpg ~ am, data = mtcars)
    expect_error(
      mtcars |> zgt.test(mpg ~ am),
      "'formula' missing or incorrect")
  }
})

test_that("docs for zfunction, zfold, and zfitter are combined", {
  skip("Need to combine docs for zfunction, zfold, and zfitter")
})

context("zfitter")

test_that("zfitter works", {

  # Create a custom version of zlm, using zfitter
  zzlm <- zfitter(lm)
  zzlm_stats <- zfitter(stats::lm)

  # Test usage in the context of regular parameters
  m.lm         <- lm(dist~speed, cars)
  m.zzlm       <- zzlm(cars, dist~speed)
  m.zzlm_stats <- zzlm_stats(cars, dist~speed)
  expect_equal(m.zzlm, m.lm)
  expect_equal(m.zzlm_stats, m.lm)

  # Test usage in the context of dplyr pipes
  if ( require("dplyr", warn.conflicts=FALSE) ) {
    m.lm.p    <- cars %>% lm(dist~speed, data=.)
    m.zzlm.p  <- cars %>% zlm(dist~speed)
    expect_equal(m.zzlm.p, m.lm.p)
  }

  # Test usage in the context of native pipes
  if ( getRversion() >= "4.1" ) {
    m.zzlm.np <- cars |> zzlm(dist~speed)
    expect_equal(m.zzlm.np, m.lm)
  }

})

test_that("zfitter error checking works",{

  # These should all be errors
  expect_error(zfitter())
  expect_error(zfitter(""))
  expect_error(zfitter("lm"))
  expect_error(zfitter(a_missing_function))

  # The target function must have both function and data parameters
  expect_error(zfitter(grep))
  expect_error(zfitter(within))

})


