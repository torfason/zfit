

context("zprint")
test_that("zprint works", {

  # zprint should print the sum, but return the original
  expect_output( {returned <- zprint(cars, sum)}, "2919" )
  expect_equal( returned, cars )

  # With no function passed, zprint should be equivalent to print
  expect_output( {returned <- zprint("abcde")}, "abcde" )
  expect_equal( returned, "abcde" )

  # It should work to pass additional arguments to the function
  if ( require("dplyr", warn.conflicts=FALSE) ) {
    expect_output({
      cw_subset <- chickwts %>%
        zprint(count, feed, sort=TRUE) %>%
        filter(feed=="soybean")
    }, "soybean 14")
    expect_equal(cw_subset, filter(chickwts, feed=="soybean"))
  }

})
