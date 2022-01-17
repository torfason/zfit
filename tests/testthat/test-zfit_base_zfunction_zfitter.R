
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


context("zfitter_zlm_robust")

test_that("zfitter works with estimatr::lm_robust()",{

  if ( require("estimatr") ) {

    # Create a pipe-friendly version of lm_robust
    zlm_robust <- zfitter(estimatr::lm_robust)

    # Assign to local variabl
    lm_robust <- estimatr::lm_robust

    # Test it
    m.lm_robust  <- lm_robust(dist~speed, data=cars)
    m.zlm_robust <- zlm_robust(cars, dist~speed)
    expect_equal(m.zlm_robust, m.lm_robust)

    # With additinal params in ellipsis
    m.lm_robust.xtra  <- lm_robust(dist~speed, data=cars, weights=dist)
    m.zlm_robust.xtra <- zlm_robust(cars, dist~speed, weights=dist)
    expect_equal(m.zlm_robust.xtra, m.lm_robust.xtra)
  }

})


context("zfitter_zpolr")
test_that("zfitter works with MASS::polr()",{

  if ( require("MASS", warn.conflicts=FALSE) ) {

    zpolr <- zfitter(polr)
    m.polr <- polr(data=housing, formula=Sat ~ Infl + Cont, weights=Freq)
    m.zpolr <- zpolr(housing, Sat ~ Infl + Cont, weights=Freq)
    expect_equal(m.zpolr, m.polr)

    # Note that the original data set must be available for using summary()
    # with a polr object. If the data set is temporary (changed in the pipe),
    # it is important to specify Hess=TRUE when calling polr/zpolr
    s.zpolr <- summary(m.zpolr)
  }
})


