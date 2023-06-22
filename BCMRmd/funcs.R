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
make_new_gct <- function(gct, mat, cdesc=NULL, rdesc=NULL, cid=NULL, rid=NULL) {
  # make a new gct object with the same metadata as the original
  #browser()

  if (is.null(cdesc)) {
    .cdesc <- gct@cdesc
  } else {
    .cdesc <- cdesc
  }
  if (is.null(cid)) {
    .cid <- gct@cid
  } else {
    .cid <- cid
  }
  if (is.null(rdesc)) {
    .rdesc <- gct@rdesc
  } else {
    .rdesc <- rdesc
  }
  if (is.null(rid)) {
    .rid <- gct@rid
  } else {
    .rid <- rid
  }
  #browser()

  new("GCT", mat = mat, rid = .rid, cid = .cid, rdesc = .rdesc, cdesc = .cdesc, )
}
recycle_colors <- function(type = "qual", n = 8) {
  # original_palette <- brewer_pal(palette = palette_name)(min(n, 8))
  original_palette <- brewer_pal(type = "qual", palette = 2)(min(n, 8))
  recycled_palette <- rep_len(original_palette, length.out = n)
  return(recycled_palette)
}
.immune_signature_gids <- c(
  "920",
  "925",
  "3458",
  "3558",
  "7124"
  )
make_random_gct <- function() {
  set.seed(369)
  .mat <- matrix(runif(10000), nrow = 1000, ncol = 10)
  .rids <- seq(1, dim(.mat)[1]) %>% as.character()
  .cids <- seq(1, dim(.mat)[2]) %>% as.character()
  .cdesc <- tibble::tibble(
    metavar1 = sample(letters[1:5], 10, replace = T),
    metavar2 = sample(letters[1:5], 10, replace = T),
  )
  gct <- cmapR::GCT(mat = .mat, rid = .rids, cid = .cids, cdesc = .cdesc)
  gct
}


read_rmd_params <- function(.file){
  library(yaml)
  header <- readLines(.file)
  start_index <- which(header == "---")[1]
  end_index <- which(header == "---")[2] - 1
  yaml_header <- paste(header[start_index:(end_index)], collapse = "\n")
  params <- yaml.load(yaml_header, eval.expr = TRUE)$params
  params
}
