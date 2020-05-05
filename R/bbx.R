#' Functions for horizontal and vertical slicing of bbx columns
#' These functions are not vectorized and should be used to compute
#' @param bbx string or character vector of bbx'es
#' @param x,y  coordinates to sclice the bouding box at
#'
#' @return list of bbx'es appliccable for particular split
#' @export
#'
#' @examples
#' bbx_slice_x("0 0 100 200", 80)
#' bbx_slice_x(c("0 0 100 200", "100 100 200 200"), c(80, 150))
#'
#' @rdname bbx_slice
#'
bbx_slice_x <- function(bbx, x){
  m <- bbx_to_bbm(bbx)
  list(left=coords_to_bbx(m[,1],m[,2], x-1, m[,4]),
       right=coords_to_bbx(x, m[,2], m[,3], m[,4]))
}

#' @export
#'
#' @examples
#' bbx_slice_y("0 0 100 200", 120)
#' bbx_slice_y(c("0 0 100 200", "100 100 200 200"), c(120,150))
#' @rdname bbx_slice
bbx_slice_y <- function(bbx, y){
  m <- bbx_to_bbm(bbx)
  list(top=coords_to_bbx(m[,1], m[,2], m[,3], y-1),
       bottom=coords_to_bbx(m[,1],y, m[,3], m[,4]))
}

#' @export
#'
#' @examples
#' bbx_slice_xy("0 0 100 200", 50, 100)
#' bbx_slice_xy(c("0 0 100 200", "100,100, 200, 200"), c(50, 150), c(100, 150))
#' @rdname bbx_slice
bbx_slice_xy <- function(bbx, x, y){
  m <- bbx_to_bbm(bbx)
  list(top_left    =coords_to_bbx(m[,1], m[,2], x-1, y-1),
       top_right   =coords_to_bbx(x, m[,2],m[,3],y-1),
       bottom_left =coords_to_bbx(m[,1], y, x-1, m[,4]),
       bottom_right=coords_to_bbx(x,y, m[,3],m[,4]))
}

#' Functions for aggregating bbx objects
#' These functions can perform union and intersection operations on bbx objects
#' @param bbx character vector of bounding boxes to perform operation on
#' @param fx1,fy1,fx2,fy2 functions to use for aggregating x1, y1, x2, y2, respectively. Defaults to `min` for x1,y1 and `max` for x2,y2
#' @param bbx2 optional character vector of bounding boxes to element-wise aggregation with `bbx`.
#' If specified, needs to be length 1 or equal in length to `bbx`.
#'
#' @return bbx or missing value, if result is invalid bounding box
#' @export
#'
#' @examples
#' bbx_union(c("5 1 7 3", "2 4 6 8"))
#' bbx_union2(c("5 1 7 3", "2 4 6 8"), c("1 1 1 1"))
#' bbx_intersect(c("5 1 7 3", "2 4 6 8")) # should return NA
#' bbx_intersect("5 1 7 3", "2 2 6 8")
#' @rdname bbx_aggregate
#'

bbx_union <- function(bbx, fx1=min, fy1=min, fx2=max, fy2=max){
  m <- bbx_to_bbm(bbx)
  coords_to_bbx(fx1(m[,1]), fy1(m[,2]), fx2(m[,3]), fy2(m[,4]))
}

#' @rdname bbx_aggregate
#' @export
bbx_union2 <- function(bbx, bbx2){
  if(length(bbx)==1L && !is.null(bbx2))
    bbx <- rep.int(bbx, times=length(bbx2))
  if(length(bbx2)==1L)
    bbx2 <- rep.int(bbx2, times=length(bbx))
  stopifnot(length(bbx)==length(bbx2))
  m <- bbx_to_bbm(bbx)
  m2 <- bbx_to_bbm(bbx2)
  return(coords_to_bbx(pmin(m[,1], m2[,1]), pmin(m[,2], m2[,2]),
                        pmax(m[,3], m2[,3]), pmax(m[,4], m2[,4])))
}

#' @rdname bbx_aggregate
#' @export
bbx_intersect <- function(bbx, bbx2=NULL){
  if(length(bbx)==1L && !is.null(bbx2))
    bbx <- rep.int(bbx, times=length(bbx2))
  if(length(bbx2)==1L)
    bbx2 <- rep.int(bbx2, times=length(bbx))

  m <- bbx_to_bbm(bbx)

  if(!is.null(bbx2)){
    m2 <- bbx_to_bbm(bbx2)
    return(coords_to_bbx(pmax(m[,1], m2[,1]), pmax(m[,2], m2[,2]),
                          pmin(m[,3], m2[,3]), pmin(m[,4], m2[,4])))
  }

  coords_to_bbx(max(m[,1]), max(m[,2]), min(m[,3]), min(m[,4]))
}

#' Predicate functions for matching bbxes
#' These functions can check whether intersection operation on bbx objects returns non-NA result
#' @param bbx character vector of bounding boxes to perform operation on
#' @param bbx2 optional character vector of bounding boxes to element-wise aggregation with `bbx`.
#' If specified, needs to be length 1 or equal in length to `bbx`.
#'
#' @return logical value of whether or not the pair of bbxes intersect
#' @export
#'
#' @examples
#' bbx_intersects(c("5 1 7 3", "2 4 6 8")) # should return FALSE
#' bbx_intersects("5 1 7 3", "2 2 6 8") # should return TRUE
#' @rdname bbx_predicates
#'
bbx_intersects <- function(bbx, bbx2=NULL){
  bbx_i <- bbx_intersect(bbx, bbx2)
  !is.na(bbx_i)
}

#' Functions for validating bbx
#' These functions can check whether specified bbx is valid, i.e. x1 <= x2 and y1 <= y2
#' @param bbx character vector bounding boxes to validate
#'
#' @return a vector of logical values
#' @export
#'
#' @examples
#' bbx_is_valid("0 0 100 200")
#' bbx_validate(c("5,4,6,3", "1,1,5,6"))
#' @rdname bbx_valid
#'
bbx_is_valid <- function(bbx){
  m <- bbx_to_bbm(bbx)
  m[,3]>=m[,1] & m[,4]>=m[,2]
}

#' @rdname bbx_valid
#' @return original vector with NA for invalid bbxes
#' @export
bbx_validate <- function(bbx){
  ifelse(bbx_is_valid(bbx), bbx, NA_character_)
}
