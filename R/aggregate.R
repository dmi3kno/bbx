bbx_agg <- function(bbx, fx1, fy1, fx2, fy2){
  m <- bbx_to_bbm(bbx)
  coords_to_bbx(fx1(m[,1]), fy1(m[,2]), fx2(m[,3]), fy2(m[,4]))
}

bbx_agg2 <- function(bbx, bbx2, fx1, fy1, fx2, fy2){
  if(length(bbx)==1L && !is.null(bbx2))
    bbx <- rep.int(bbx, times=length(bbx2))
  if(length(bbx2)==1L)
    bbx2 <- rep.int(bbx2, times=length(bbx))
  stopifnot(length(bbx)==length(bbx2))
  m <- bbx_to_bbm(bbx)
  m2 <- bbx_to_bbm(bbx2)
  return(coords_to_bbx(fx1(m[,1], m2[,1]), fy1(m[,2], m2[,2]),
                       fx2(m[,3], m2[,3]), fy2(m[,4], m2[,4])))
}

#' Functions for aggregating bbx objects
#' These functions can perform union and intersection operations on bbx objects
#' @param bbx character vector of bounding boxes to perform operation on
#' @param fx1,fy1,fx2,fy2 functions to use for aggregating x1, y1, x2, y2, respectively. Defaults to `min` for x1,y1 and `max` for x2,y2
#' @param bbx2 optional character vector of bounding boxes to element-wise aggregation with `bbx`.
#' If specified, needs to be length 1 or equal in length to `bbx`.
#'
#' @return bbx or missing value, if result is invalid bounding box
#'
#' @examples
#' bbx_union(c("5 1 7 3", "2 4 6 8"))
#' bbx_union(c("5 1 7 3", "2 4 6 8"), c("1 1 1 1"))
#' bbx_intersect(c("5 1 7 3", "2 4 6 8")) # should return NA
#' bbx_intersect("5 1 7 3", "2 2 6 8")
#' @rdname bbx_aggregate
#' @export
bbx_aggregate <- function(bbx, bbx2=NULL, fx1, fy1, fx2, fy2){
  if(!is.null(bbx2))
    bbx_agg2(bbx, bbx2, fx1, fy1, fx2, fy2)
  bbx_agg(bbx, fx1, fy1, fx2, fy2)
}

#' @rdname bbx_aggregate
#' @export
bbx_union <- function(bbx, bbx2=NULL){
  if(!is.null(bbx2))
    bbx_agg2(bbx, bbx2, pmin, pmin, pmax, pmax)
  bbx_agg(bbx, min, min, max, max)
}

#' @rdname bbx_aggregate
#' @export
bbx_intersect <- function(bbx, bbx2=NULL){
  if(!is.null(bbx2))
    bbx_agg2(bbx, bbx2, pmax, pmax, pmin, pmin)
  bbx_agg(bbx, max, max, min, min)
}


