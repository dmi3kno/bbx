#' Convert bbx to row/column list and back
#'
#' @param bbx character vector of bbxes
#' @param l list of numeric vectors, representing bbxes or bbx coordinates (for `bbx_to_rlst()` and `bbx_to_clst()`, respectively)
#' @return list numeric vectors representing bbxes
#' @rdname bbx_list
#' @examples
#' l <- c("0 0 5 5", "5,5,10,10")
#' bbx_to_rlst(l)
#' bbx_to_clst(l)
#' @export
bbx_to_rlst <- function(bbx){
  lapply(strsplit(bbx, ",\\s?|\\s+"), as.numeric)
}

#' @rdname bbx_list
#' @return list numeric vectors representing bbx coordinates
#' @export
bbx_to_clst <- function(bbx){
  bb_rlst <- bbx_to_rlst(bbx)
  lst_transpose(bb_rlst)
}


#' @return character vector of bbxes
#' @rdname bbx_list
#' @examples
#' l <- list(c(0,0,5,5), c(5,0,10,5), c(0,5,5,10), c(5,5,10,10))
#' rlst_to_bbx(l)
#' @export
rlst_to_bbx <- function(l){
  m <- unname(Reduce(rbind,l))
  bbm_to_bbx(m)
}


#' @return character vector of bbxes
#' @rdname bbx_list
#' @examples
# l <- list(c(0,5,0,5,0),
#           c(0,0,5,5,0),
#           c(5,10,5,10,10),
#           c(5,5,10,10,10))
#' clst_to_bbx(l)
#' @export
clst_to_bbx <- function(l){
  m <- unname(Reduce(rbind,l))
  bbm_to_bbx(t(m))
}

#' Convert bbx to matrix and matrix/vectors to bbx
#'
#' @param bbx character vector of bbxes (top-left coordinates). Expects four integers separated by comma or space
#' @param m matrix, where columns represent x1, y1, x2, y2 of bbx
#' @param x1,y1,x2,y2 vectors representing x1, y1, x2, y2 of bbx
#' @return character vector of bbxes
#' @rdname bbx_matrix
#'
#' @examples
#' bbx_to_bbm(c("0 0 5 5", "5 5 10 10"))
#' @export
bbx_to_bbm <- function(bbx){
  bb_rlst <- bbx_to_rlst(bbx)
  do.call(rbind, bb_rlst)
}


#'
#' @examples
#' bbm_to_bbx(matrix(c(0,0,5,5,5,5,10,10), nrow=2, byrow=TRUE))
#'
#' @rdname bbx_matrix
#' @export
bbm_to_bbx <- function(m){
  stopifnot(ncol(m)==4L)
  bbx_validate(apply(m, 1, paste, collapse=" "))
}


#' @examples
#' coords_to_bbx(c(0,5,0,5),c(0,0,5,5),
#'                c(5,10,5,10), c(5,5,10,10))
#'
#' @rdname bbx_matrix
#' @export
coords_to_bbx <- function(x1, y1, x2, y2){
  bbx_validate(paste(x1, y1, x2, y2))
}

#' Convert bbm (matrix of bounding boxes) to elements of slope-intercept matrix or vector of angles
#'
#' @param m,m2 matrix, where columns represent x1, y1, x2, y2 of bbx
#' @return matrix of slopes and intercepts
#' @export
#'
#' @examples
#' m <-bbx_to_bbm(c("0 0 5 5", "5 5 10 10"))
#' bbm_to_abm(m)
#'
#' @rdname bbm_lm
bbm_to_abm <- function(m){
  slope <- (m[,4]-m[,2])/(m[,3]-m[,1])
  intercept <- m[,2]-slope*m[,1]
  cbind(slope=slope,
        intercept=intercept)
}

#' @return vector of angles
#' @export
#'
#' @examples
#' m <-bbx_to_bbm(c("0 0 5 5", "5 5 10 10"))
#' bbm_to_angle(m)
#'
#' @rdname bbm_lm
bbm_to_angle <- function(m, m2=NULL){
  slope <- (m[,4]-m[,2])/(m[,3]-m[,1])
  if(is.null(m2)) return(atan(slope)*180/pi)
  slope2 <- (m2[,4]-m2[,2])/(m2[,3]-m2[,1])
  atan(abs((slope2-slope)/(1+slope*slope2)))*180/pi
}

