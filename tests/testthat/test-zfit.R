

context("zlm")
test_that("zlm works", {

    # Test usage in the context of regular parameters
    m.lm   <- lm(dist~speed,cars)
    m.zlm  <- zlm(cars,dist~speed)
    expect_equal(m.zlm,m.lm)

    # Test usage in the context of pipes (if  dplyr installed)
    if ( requireNamespace("dplyr", quietly = TRUE) ) {
        m.lm.p   <- cars %>% lm(dist~speed,data=.)
        m.zlm.p  <- cars %>% zlm(dist~speed)
        expect_equal(m.zlm.p,m.lm.p)
    }

})


context("zglm")
test_that("zglm works", {

    # Test usage in the context of regular parameters
    # First without specifying family
    m.glm   <- glm(dist~speed, data=cars)
    m.zglm  <- zglm(cars, dist~speed)
    expect_equal(m.zglm,m.glm)

    # Then we specify a family
    m.glm   <- glm(case~spontaneous+induced, binomial(), infert)
    m.zglm  <- zglm(infert, case~spontaneous+induced, binomial())
    expect_equal(m.zglm,m.glm)

    # Test usage in the context of pipes (if  dplyr installed)
    if ( requireNamespace("dplyr", quietly = TRUE) ) {
        # Test usage in the context of pipes
        m.glm.p   <- cars %>% glm(dist~speed, data=.)
        m.zglm.p  <- cars %>% zglm(dist~speed)
        expect_equal(m.zglm.p,m.glm.p)
    }

})


context("zlogit")
test_that("zlogit works", {

    # Test usage in the context of regular parameters
    # These three forms should be
    m.glm    <- glm(case~spontaneous+induced, binomial(link="logit"), infert)
    m.zglm   <- zglm(infert, case~spontaneous+induced, binomial(link="logit"))
    m.zlogit <- zlogit(infert, case~spontaneous+induced)
    expect_equal(m.zlogit,m.zglm)
    expect_equal(m.zlogit,m.glm)

    # Test usage in the context of pipes (if  dplyr installed)
    if ( requireNamespace("dplyr", quietly = TRUE) ) {
        # Test usage in the context of pipes
        m.glm.p    <- infert %>% glm(case~spontaneous+induced, family=binomial(link="logit"), data=.)
        m.zlogit.p <- infert %>% zlogit(case~spontaneous+induced)
        expect_equal(m.zlogit.p,m.glm.p)
    }

})


context("zprobit")
test_that("zprobit works", {

    # Test usage in the context of regular parameters
    # These three forms should be
    m.glm    <- glm(case~spontaneous+induced, binomial(link="probit"), infert)
    m.zglm   <- zglm(infert, case~spontaneous+induced, binomial(link="probit"))
    m.zprobit <- zprobit(infert, case~spontaneous+induced)
    expect_equal(m.zprobit,m.zglm)
    expect_equal(m.zprobit,m.glm)

    # Test usage in the context of pipes (if  dplyr installed)
    if ( requireNamespace("dplyr", quietly = TRUE) ) {
        # Test usage in the context of pipes
        m.glm.p    <- infert %>% glm(case~spontaneous+induced, family=binomial(link="probit"), data=.)
        m.zprobit.p <- infert %>% zprobit(case~spontaneous+induced)
        expect_equal(m.zprobit.p,m.glm.p)
    }

})


context("zpoisson")
test_that("zprobit works", {

    # # To originally get the data suitable for testing poisson
    # # https://stats.idre.ucla.edu/r/dae/poisson-regression/
    # d.org <- readr::read_csv("https://stats.idre.ucla.edu/stat/data/poisson_sim.csv",
    #                      col_types= cols(
    #                       id = col_integer(),
    #                       num_awards = col_integer(),
    #                       prog = col_integer(),
    #                       math = col_double()
    #                     ))
    # d <- d.org %>%
    #     mutate( id = factor(id),  prog = factor(prog, levels=1:3,
    #             labels=c("General", "Academic",  "Vocational"))) %>%
    #     relocate(id, prog, math, num_awards) %>%
    #     arrange(d, id)
    # d %>% write_rds("tests/testthat/datasets/awards.rds", compress="xz", compression=9L)

    # Test usage in the context of regular parameters
    # These three forms should be
    awards  <- readRDS("datasets/awards.rds")
    m.glm   <- glm(num_awards ~ prog + math, family="poisson", awards)
    m.zglm  <- zglm(awards, num_awards ~ prog + math, "poisson")
    m.zpoisson <- zpoisson(awards, num_awards ~ prog + math)
    expect_equal(m.zpoisson,m.zglm)
    expect_equal(m.zpoisson,m.glm)

})
