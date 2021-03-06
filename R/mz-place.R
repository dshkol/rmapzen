#' Get details on a place
#'
#' Search functions (e.g. \code{\link{mz_search}}) return identification numbers,
#' or \code{gid}s. Use \code{mz_place} to retrieve more details about the place.
#' See \url{https://mapzen.com/documentation/search/place/} for details. This
#' function is generic, and can take a character vector of IDs, or a
#' \code{mapzen_geo_list} as returned by \code{\link{mz_search}} and friends.
#'
#' @param ids A character vector of gids (see details), or a \code{mapzen_geo_list}
#' @param ... Arguments passed on to methods
#' @param gid The name of the \code{gid} field to use. Search results may include,
#' in addition to the \code{gid} for the search result itself (the default), the
#' \code{gid}s for the country, region, county, locality and neighborhood.
#' @param api_key Your Mapzen API key. Defaults to \code{Sys.getenv("MAPZEN_KEY")}
#' @name mz_place
#' @export
mz_place <- function(ids, ..., api_key = mz_key()) UseMethod("mz_place")

build_place_url <- function(ids, api_key = mz_key()) {
    ids <- string_array(ids)

    query <- list(
        ids = ids,
        api_key = api_key
    )

    do.call(search_url, c(endpoint = "place", query))
}

#' @rdname mz_place
#' @export
mz_place.character <- function(ids, ..., api_key = mz_key()) {
    search_get(build_place_url(ids, api_key = api_key))
}

#' @rdname mz_place
#' @export
mz_place.mapzen_geo_list <- function(ids, ..., gid = "gid", api_key = mz_key()) {
    geolist <- ids
    getgid <- function(feature) {
        feature$properties[[gid]]
    }

    ids <- vapply(geolist$features, getgid, FUN.VALUE = character(1))
    search_get(build_place_url(ids, api_key))
}

