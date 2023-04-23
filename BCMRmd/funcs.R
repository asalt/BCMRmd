myzscore <- function(value, minval = NA, remask = TRUE) {
  mask <- is.na(value)
  if (is.na(minval)) {
    minval <- min(value, na.rm = TRUE)
  }
  value[is.na(value)] <- minval
  out <- scale(value)
  if (remask == TRUE) {
    out[mask] <- NA
  }
  return(out)
}
dist_no_na <- function(mat) {
  mat[is.na(mat)] <- min(mat, na.rm = TRUE)
  edist <- dist(mat)
  return(edist)
}
make_new_gct <- function(gct, mat) {
  # make a new gct object with the same metadata as the original
  new("GCT", mat = mat, rid = gct@rid, cid = gct@cid, rdesc = gct@rdesc, cdesc = gct@cdesc, )
}
recycle_colors <- function(type = "qual", n = 8) {
  # original_palette <- brewer_pal(palette = palette_name)(min(n, 8))
  original_palette <- brewer_pal(type = "qual", palette = 2)(min(n, 8))
  recycled_palette <- rep_len(original_palette, length.out = n)
  return(recycled_palette)
}
