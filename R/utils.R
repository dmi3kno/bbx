lst_transpose <- function(l){
  lapply(seq_along(l[[1]]),
         function (i) sapply(l, "[", i))
}
