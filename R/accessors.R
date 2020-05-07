
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

#' Functions for accessing bbx properties
#' These functions can calculate various metrix of bbx
#' @param bbx character vector of bounding boxes to pad
#' @details Functions `bbx_h` and `bbx_w` return height and width, respectively.
#' Functions `bbx_x` and `bbx_y` return `x` and `y` offset.
#'
#' @return a vector of values
#' @rdname bbx_info
#'
#' @examples
#' bbx_area("100 100 200 200")
#' bbx_h("100 100 200 200")
#' bbx_w("100 100 200 200")
#' @export
bbx_area <- function(bbx){
  m <- bbx_to_bbm(bbx)
  (m[,3]-m[,1])*(m[,4]-m[,2])
}

#' @rdname bbx_info
#' @export
bbx_h <- function(bbx){
  m <- bbx_to_bbm(bbx)
  m[,4]-m[,2]
}

#' @rdname bbx_info
#' @export
bbx_w <- function(bbx){
  m <- bbx_to_bbm(bbx)
  m[,3]-m[,1]
}

#' @rdname bbx_info
#' @export
bbx_x <- function(bbx){
  m <- bbx_to_bbm(bbx)
  m[,1]
}

#' @rdname bbx_info
#' @export
bbx_y <- function(bbx){
  m <- bbx_to_bbm(bbx)
  m[,2]
}
