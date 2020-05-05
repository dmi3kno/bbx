# this file was created with
# usethis::use_data_raw("devstuff")

usethis::use_description(fields = list(
  # Package = "yourcoolpackagename", # default, no need to specify
  # Version = "0.0.0.9000", # default, no need to specify
  Title = "Frame your world",
  Description = "Utility functions for operating with bounding boxes and geometries for magick images.", # at least one sentence
  `Authors@R` = 'c(person("Dmytro", "Perepolkin",
                   email = "dperepolkin@gmail.com", role = c("aut", "cre"),
                   comment = c(ORCID = "0000-0001-8558-6183")))',
  # Encoding = "UTF-8", # default, no need to specify
  # LazyData = "true" # default, no need to specify
  URL = "https://github.com/dmi3kno/bbx",
  BugReports = "https://github.com/dmi3kno/bbx/issues",
  Language =  "en" # insert new fields above this line
  )
)
usethis::use_mit_license("Dmytro Perepolkin")
usethis::use_git()
#usethis::browse_github_pat()
usethis::use_github()
usethis::use_r("bbx")
usethis::use_news_md()
usethis::use_package_doc()
usethis::use_readme_rmd()
# usethis::use_package("thepackageyouused") # this is for specifying dependencies. Use instead of library(pkgname)
usethis::use_lifecycle_badge("Experimental")
#usethis::use_testthat()
#usethis::use_test()
#usethis::use_travis()
#usethis::use_appveyor()
#usethis::use_pkgdown()
#usethis::use_pkgdown_travis()
#usethis::use_coverage()
#and more
