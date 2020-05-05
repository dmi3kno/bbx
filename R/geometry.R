#' Convert bbx to magick-geometry
#'
#' @param bbx character vector of bounding boxes to be converted to geometries
#' @param g character vector of geometries to be converted to bbxes
#'
#' @return character vector of magick-compliant geometry string representing bounding box area in the format  "width x height +x_off +y_off" (https://www.imagemagick.org/Magick++/Geometry.html)
#' @seealso [magick::geometry] for converting integers (four individual columns) to geometry
#' @export
#' @rdname bbx_geometry
#'
#' @examples
#' # area from c(0,0) to c(100,200) counting from top left
#' bbx_to_geometry("0 0 100 200")
#' bbx_to_geometry(c("0 0 100 200", "100,100,200, 200"))
#' geometry_to_bbx(c("100x200+12+14", "100x200", "+12+14", "x200+12+14"))
bbx_to_geometry <- function(bbx){
  m <- bbx_to_bbm(bbx)
  paste0(m[,3] - m[,1], "x", m[,4] - m[,2], "+", m[,1], "+", m[,2])
}

#' @rdname bbx_geometry
#' @export
geometry_to_bbx <- function(g){
  geom_pattern <- "^(?:(\\d+)?(?:x(\\d+))?)?(?:\\+?(\\-?\\d+)\\+?(\\-?\\d+))?$"
  # list of matches
  m_lst <- regmatches(g, regexec(geom_pattern, g))
  # catching missing values and coercing them to zero
  m0_lst <- lapply(m_lst, function(x)
                          ifelse(x=="", "0", x))
  # convert to numeric
  n_lst <- lapply(m0_lst, function(i)
                            as.numeric(i[-1]))
  gm <- do.call(rbind, n_lst)
  coords_to_bbx(gm[,3], gm[,4], gm[,3]+gm[,1], gm[,4]+gm[,2])
}
