#' Barplot of species number in GBIF and BIOSHIFTS
#'
#' @author Nicolas Casajus \email{nicolas.casajus@fondationbiodiversite.fr}
#' 
#' @date 2022/03/08



## Import BIOSHIFTS data ----

bioshifts <- read.csv(here::here("data", "standardized_names_rechecked.csv"))


## Import GBIF data ----

all_records <- readRDS(here::here("outputs", "gbifs_n_records.rds"))


## Sum records per species (if several GBIF keys by species) ----

x <- tapply(all_records$"n_records", all_records$"taxon", sum)

all_records <- data.frame("taxon"     = names(x), 
                          "n_records" = x, 
                          row.names   = NULL)


## Remove species with < 100 GBIF records ----

all_records <- all_records[all_records$"n_records" > 99, ]


## Add taxonomy information ----

all_records <- merge(all_records, bioshifts, 
                     by.x = 'taxon', by.y = "SpeciesChecked",
                     all.x = TRUE, all.y = FALSE)


## Count species per class ----

bioshifts <- data.frame(table(bioshifts$"class"))
gbif      <- data.frame(table(all_records$"class"))

tab <- merge(bioshifts, gbif, by = "Var1")
colnames(tab) <- c("Class", "Bioshifts", "GBIF")

tab <- tab[order(tab$"Bioshifts", decreasing = FALSE), ]


## Barplot ----

png(filename = here::here("figures", "gbif_vs_bioshifts.png"),
    width = 12, height = 8, units = "in", res = 600, pointsize = 14)

par(mar = c(2.5, 6, 0.5, 0.5), family = "serif", mgp = c(1.5, 0.15, 0), 
    font.lab = 2, xaxs = "i", yaxs = "i")


## Plot dimensions ----

barplot(tab$"Bioshifts", horiz = TRUE, las = 1, cex.names = 0.75, col = NA,
        names.arg = tab$"Class", xlab = "Number of species", border = NA,
        xlim = c(0, 6850), lwd.ticks = 0)


## Grid ----

abline(v = seq(0, 7500, 500), lty = 3, col = "lightgray")


## Plot coordinates ----

x <- barplot(tab$"GBIF", horiz = TRUE, plot = FALSE)


## Add data ----

barplot(tab$"Bioshifts", add = TRUE, col = "red", horiz = TRUE, 
        names.arg = FALSE, axes = FALSE, border = "red")

barplot(tab$"GBIF", add = TRUE, col = "black", horiz = TRUE, 
        names.arg = FALSE, axes = FALSE, border = "black")


## Add legend ----

text(par()$usr[2], 2, "BIOSHIFTS species", pos = 2, font = 2, col = "red")
text(par()$usr[2], 4, "GBIF species (n records > 100)", pos = 2, font = 2, 
     col = "black")


## Add bars values ----

percs  <- round(100 * (tab$"Bioshifts" - tab$"GBIF") / tab$"Bioshifts", 0)
percs <- paste0("(", percs, "%)")

labels <- paste(tab$"GBIF", "/", tab$"Bioshifts")
labels <- paste(labels, percs)

text(x = tab$"Bioshifts", y = x[ , 1] - 0.1, labels, pos = 4, cex = 0.75, font = 2)


## Add plot frame ----

box()

dev.off()
