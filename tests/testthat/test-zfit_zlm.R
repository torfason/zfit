
context("zlm")
test_that("zlm works", {

  # Test usage in the context of regular parameters
  m.lm   <- lm(dist~speed, cars)
  m.zlm  <- zlm(cars, dist~speed)
  expect_equal(m.zlm, m.lm)

  # Test usage in the context of pipes
  if ( require("dplyr", warn.conflicts=FALSE) ) {
    m.lm.p   <- cars %>% lm(dist~speed, data=.)
    m.zlm.p  <- cars %>% zlm(dist~speed)
    expect_equal(m.zlm.p, m.lm.p)
  }

})
