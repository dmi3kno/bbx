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

#' Functions for padding bbx
#' These functions can "pad" (increase size of) bbx
#' @param bbx character vector of bounding boxes to pad
#' @param n integer number of pixels to add. If a `word` is provided, `n` is interpreted as number of characters.
#' @param word optional character vector of words contained in bbxes
#' @param side "left", "right" (for `bbx_pad_width()`), "up", "down" (for `bbx_pad_height()`) or "both" which side to pad
#'
#' @return a vector of validated bbxes
#' @rdname bbx_pad
#'
#' @examples
#' bbx_pad_width("5 5 10 20", word="There")
#' bbx_pad_width("5 5 10 20", 1)
#' bbx_pad_height("5 5 10 20", word="There/nbe/ndragons")
#' bbx_pad_height("5 5 10 20", 1)
#' @export
bbx_pad_width <- function(bbx, n=1, word=NULL, side="both"){
  m <- bbx_to_bbm(bbx)
  if(!is.null(word))
    n <- (m[,3]-m[,1])/nchar(word)*n
  if(side=="left"|side=="both")
    m[,1] <- m[,1]-n
  if(side=="right"|side=="both")
    m[,3] <- m[,3]+n

  bbm_to_bbx(m)
}

#' @rdname bbx_pad
#' @export
bbx_pad_height <- function(bbx, n=1, word=NULL, side="both"){
  m <- bbx_to_bbm(bbx)
  if(!is.null(word)){
    n_lines <-  lengths(regmatches(word, gregexpr("\n", word)))+1
    n <- (m[,4]-m[,2])/n_lines*n
  }
  if(side=="up"|side=="both")
    m[,2] <- m[,2]-n
  if(side=="down"|side=="both")
    m[,4] <- m[,4]+n

  bbm_to_bbx(m)
}

#' Functions for calculating with bbx
#' These functions can calculate various metrix of bbx
#' @param bbx character vector of bounding boxes to pad
#'
#' @return a vector of validated bbxes
#' @rdname bbx_math
#'
#' @examples
#' bbx_area("100 100 200 200")
#'
#' @export
bbx_area <- function(bbx){
  m <- bbx_to_bbm(bbx)
  (m[,3]-m[,1])*(m[,4]-m[,2])
}

#' Functions for updating certain coordinates of bbx
#' These functions can modify a vector of bbx
#' @param bbx character vector of bounding boxes to update
#' @param x1 scalar or numeric vector to update bbx with
#' @param y1 scalar or numeric vector to update bbx with
#' @param x2 scalar or numeric vector to update bbx with
#' @param y2 scalar or numeric vector to update bbx with
#'
#' @return a vector of updated and validated bbxes
#' @rdname bbx_modify
#'
#' @examples
#' bbx_reset(bbx=c("100 100 200 200", "300 400 500 600"), x2=800)
#'
#' @export
bbx_reset <- function(bbx, x1=NULL, y1=NULL, x2=NULL, y2=NULL){
  if(is.null(x1) && is.null(y1) && is.null(x2) && is.null(y2))
    return(bbx)
  if(length(x1)==4 && is.null(y1) && is.null(x2) && is.null(y2)){
    y1 <- x1[[2]]; x2 <- x1[[3]]; y2 <- x1[[4]]; x1 <- x1[[1]]}

  if(length(x1)==1) x1 <- rep.int(x1, times = length(bbx))
  if(length(y1)==1) y1 <- rep.int(y1, times = length(bbx))
  if(length(x2)==1) x2 <- rep.int(x2, times = length(bbx))
  if(length(y2)==1) y2 <- rep.int(y2, times = length(bbx))

  m <- bbx_to_bbm(bbx)

  if(!is.null(x1))
    m[,1] <- x1
  if(!is.null(y1))
    m[,2] <- y1
  if(!is.null(x2))
    m[,3] <- x2
  if(!is.null(y2))
    m[,4] <- y2

  bbm_to_bbx(m)
}
