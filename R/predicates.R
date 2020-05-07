#' Predicate functions for matching bbxes
#'
#' @param bbx character vector of bounding boxes to perform operation on
#' @param bbx2 optional character vector of bounding boxes to element-wise aggregation with `bbx`.
#' If specified, needs to be length 1 or equal in length to `bbx`.
#' @param direction by default x
#' @details
#'  These functions can check intersection(non-empty intersection geometry) or
#'  horizontal/vertical overlap of segments.
#'
#' @return logical value
#'
#' @examples
#' bbx_intersects("5 1 7 3", "2 2 6 8") # should return TRUE
#' bbx_ovelaps("100 100 200 200", "120, 220, 180, 240") # should be TRUE
#'
#' @rdname bbx_predicates
#' @export
bbx_intersects <- function(bbx, bbx2){
  bbx_i <- bbx_agg2(bbx, bbx2, pmax, pmax, pmin, pmin)
  !is.na(bbx_i)
}

#'
#' @rdname bbx_predicates
#' @export
bbx_ovelaps <- function(bbx, bbx2, direction="x"){
  bbm <- bbx_to_bbm(bbx)
  bbm2 <- bbx_to_bbm(bbx2)
  if (direction=="x")
    return(!(bbm2[,3]<bbm[,1] | bbm[,3]<bbm2[,1]))
  !(bbm2[,4]<bbm[,2] | bbm[,4]<bbm2[,2])
}

