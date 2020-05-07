
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
