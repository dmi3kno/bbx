
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

#' Functions for transforming certain coordinates of bbx
#' These functions can modify a vector of bbx
#' @param bbx character vector of bounding boxes to update
#' @param x scalar or numeric vector to update bbx with
#' @param y scalar or numeric vector to update bbx with
#'
#' @return a vector of updated and validated bbxes
#' @rdname bbx_transform
#'
#' @examples
#' bbx_translate(c("100 100 200 200", "300 400 500 600"), x=111, y=222)
#'
#' @export
bbx_translate <- function(bbx, x=NULL, y=NULL){
  if(is.null(x) & is.null(y))
    return(bbx)
  if(is.character(x) & is.null(y)){
    b <- geometry_to_bbx(x)
    bm <- bbx_to_bbm(b)
    x <- bm[,1]
    y <- bm[,2]
  }

  bbm <- bbx_to_bbm(bbx)
  offset_m <- matrix(rep(c(x,y,x,y), times=nrow(bbm)), byrow=TRUE, ncol=4)
  bbm_to_bbx(bbm+offset_m)
}
