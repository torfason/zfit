
test_that("external fitters work", {
  if (requireNamespace("estimatr", quietly = TRUE)) {
    zlm_robust <- zfitter(estimatr::lm_robust)
    zlm_robust(cars, speed~dist) |> expect_silent()
  }
})

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


